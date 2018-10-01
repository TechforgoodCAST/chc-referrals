require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1280, 700]

  def fake_webhook_request(url, headers: {}, body: {})
    server = Capybara.current_session.server
    conn = Faraday.new(url: "http://#{server.host}:#{server.port}")
    conn.post do |req|
      req.url(url)
      req.headers.merge!(headers)
      req.body = body.to_json
    end
  end
end
