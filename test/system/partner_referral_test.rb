require 'application_system_test_case'

class PartnerReferralTest < ApplicationSystemTestCase
  setup do
    @partner = create(:partner)
  end

  test 'Partner not found' do
    visit new_partner_referral_path('missing')
    assert_text("The page you were looking for doesn't exist.")
  end

  test 'only active Partners' do
    @partner.update(accepting_referrals: false)
    visit new_partner_referral_path(@partner)
    assert_text("The page you were looking for doesn't exist.")
  end

  test 'make Referral' do
    visit new_partner_referral_path(@partner)

    page.within_frame(find('iframe')) do
      find('.general').click
      find('.submit', visible: false).click
    end

    send_fake_webhook_request(@partner)

    assert_text('Sent 1')
  end

  test 'all Referral slots taken' do
    @partner.update(max_monthly_referrals: 0)
    visit new_partner_referral_path(@partner)
    assert_text('No more referral slots available this month.')
    assert_link('Make an Emergency referral')
  end

  test 'shows remaining availability' do
    create(:referral, partner: @partner)
    create(:referral, partner: @partner, last_state: 'accepted')
    create(:referral, partner: @partner, last_state: 'declined')
    visit new_partner_referral_path(@partner)
    assert_text('Available 8')
  end

  test 'real time update per Partner' do
    @partner2 = create(:partner)
    visit new_partner_referral_path(@partner)
    send_fake_webhook_request(@partner2)
    assert_text('Sent 0')
  end

  test 'form hidden when all Referrals used' do
    @partner.update(max_monthly_referrals: 1)
    visit new_partner_referral_path(@partner)
    send_fake_webhook_request(@partner)
    assert_text('No more referral slots available this month.')
  end

  def send_fake_webhook_request(partner)
    fake_webhook_request(
      webhooks_new_response_path(partner.webhook_token),
      headers: { 'Content-Type' => 'application/json' },
      body: { event_id: 'LtWXD3crgy' }
    )
  end
end