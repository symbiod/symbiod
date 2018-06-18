# frozen_string_literal: true

#
# Provides mocks for Slack invite API
module SlackMock
  module ClassMethods
    def slack_success_response!
      before do
        slack_response_template(ok: true)
      end
    end

    def slack_success_response_mentor!
      before do
        slack_response_mentor_template(ok: true)
      end
    end

    def slack_failed_response!
      before do
        slack_response_template({})
      end
    end

    def slack_user_already_exists!
      before do
        slack_response_template(ok: false, error: 'already_in_team')
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  def slack_response_template(payload)
    stub_request(
      :get,
      'https://slack.com/api/users.admin.invite?channels=C8KSHUPSS,C8RU3LNQ2,C8QFNNG21&set_active=true&_attempts=1&token=1234567890&email=user@test.com&first_name=User&last_name=Last'
    ).with(headers: {
             'Accept' => '*/*',
             'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
             'User-Agent' => 'Ruby'
           }).to_return(body: payload.to_json).times(1)
  end

  def slack_response_mentor_template(payload)
    stub_request(
      :get,
      'https://slack.com/api/users.admin.invite?channels=C8KSHUPSS,C8RU3LNQ2,C8QFNNG21,CB58GFAR0&set_active=true&_attempts=1&token=1234567890&email=user@test.com&first_name=User&last_name=Last'
    ).with(headers: {
             'Accept' => '*/*',
             'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
             'User-Agent' => 'Ruby'
           }).to_return(body: payload.to_json).times(1)
  end
end
