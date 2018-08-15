# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Screening::MessageToSlack do
  subject { described_class }
  let(:applicant) { create(:user, :developer, :screening_completed) }
  let(:message) do
    <<-MESSAGE.gsub(/^[\s\t]*/, '').gsub(/[\s\t]*\n/, ' ').strip
      <!here> New developer screening comleted.
      You can make a review of the applicant by clicking on the link:
      #{Rails.application.routes.url_helpers.dashboard_test_task_assignment_url(id: applicant.id)}
    MESSAGE
  end
  let(:channel) { 'bootcamp-recruiting' }
  let(:params)  { { applicant: applicant } }
  let(:service) { double }

  describe '#call' do
    before do
      allow(SlackService).to receive(:new).with(any_args).and_return(service)
    end

    context 'message is sent normally' do
      it 'success send message' do
        expect(service).to receive(:post_to_channel).with(channel, message)
        subject.call(params)
      end
    end

    context 'message was not sent to channel' do
      it 'handles exception properly' do
        expect(service)
          .to receive(:post_to_channel)
          .with(channel, message)
          .and_raise(
            SlackIntegration::FailedApiCallException,
            'Unsuccessful send message: { "ok"=>false }'
          )
        subject.call(params)
      end
    end
  end
end
