# frozen_string_literal: true

#
# Provides mocks for Slack invite API
module SlackMock
  def slack_success_response!
    before do
      stub_request(
        :get,
        'https://slack.com/api/users.admin.invite?channels=&set_active=true&_attempts=1&token=1234567890&email=user@test.com&first_name=User&last_name=Last'
      ).with(headers: {
               'Accept' => '*/*',
               'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
               'User-Agent' => 'Ruby'
             }).to_return(body: { ok: true }.to_json).times(1)
    end
  end

  def slack_failed_response!
    before do
      stub_request(:get, /slack.com/).to_return(body: {}.to_json)
    end
  end
end
