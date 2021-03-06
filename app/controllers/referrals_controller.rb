class ReferralsController < ApplicationController
  before_action :authenticate_user!, except: :new
  before_action :load_partner, except: :index
  before_action :parse_date, except: :show

  def new
    if @partner
      @referrals = @partner.referrals.by_month(@date)
      @used_referrals = @referrals.used
      @total_available = @partner.max_monthly_referrals - @used_referrals.size
    else
      render_status(404)
    end
  end

  def index
    @referrals = Referral.order(created_at: :desc).by_month(@date)
  end

  def show
    @referral = @partner.referrals.find_by(sequential_id: params[:id])
    @users = User.all - User.joins(:assignments).where('referral_id = ?', @referral)
    render_status(404) if @referral.nil?
  end

  private

  def load_partner
    @partner = Partner.active.find_by(slug: params[:slug])
  end
end
