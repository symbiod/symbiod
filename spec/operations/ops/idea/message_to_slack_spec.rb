# frozen_string_literal: true

require 'rails_helper'

describe Ops::Idea::MessageToSlack do
  subject { described_class }
  let(:idea) { create(:idea) }
  let(:message) do
    <<-MESSAGE.gsub(/^[\s\t]*/, '').gsub(/[\s\t]*\n/, ' ').strip
      <!here> New idea was added:
      #{Rails.application.routes.url_helpers.dashboard_idea_url(id: idea.id)}
    MESSAGE
  end
  let(:channel) { 'ideas' }
  let(:params)  { { idea: idea } }
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

    context 'some other exception occured' do
      it 'handles exception properly' do
        allow(service)
          .to receive(:post_to_channel)
          .with(channel, message)
          .and_raise(
            SlackIntegration::FailedApiCallException,
            'some other message'
          )
        expect { subject.call(params) }
          .to raise_error SlackIntegration::FailedApiCallException, 'some other message'
      end
    end
  end
end
