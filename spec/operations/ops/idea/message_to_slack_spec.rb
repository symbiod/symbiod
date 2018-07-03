# frozen_string_literal: true

require 'rails_helper'

describe Ops::Idea::MessageToSlack do
  subject       { described_class }
  let(:user)    { create(:user, :developer) }
  let(:channel) { 'ideas' }
  let(:message) { 'Ideas was added' }
  let(:params)  { { channel: channel, message: message } }
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
