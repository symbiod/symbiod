# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::InviteToSlack do
  subject       { described_class }
  let(:user)    { create(:user, :developer) }
  let(:params)  { { user: user } }
  let(:service) { double }
  before { user.create_developer_onboarding }

  describe '#call' do
    before do
      allow(SlackService).to receive(:new).with(any_args).and_return(service)
    end

    context 'user was not invited before' do
      context 'is mentor' do
        let(:user) { create(:user, :mentor) }

        it 'invites member to Slack' do
          expect(service).to receive(:invite).with(user, 'mentors')
          subject.call(params)
        end
      end

      context 'is developer' do
        it 'invites member to Slack' do
          expect(service).to receive(:invite).with(user, '')
          subject.call(params)
        end
      end
    end

    context 'user was invited before' do
      it 'handles exception properly' do
        expect(service)
          .to receive(:invite)
          .with(user, '')
          .and_raise(
            SlackIntegration::FailedApiCallException,
            'Unsuccessful invite api call: {"ok"=>false, "error"=>"already_invited"}'
          )
        subject.call(params)
      end
    end

    context 'some other exception occured' do
      it 'handles exception properly' do
        allow(service)
          .to receive(:invite)
          .with(user, '')
          .and_raise(
            SlackIntegration::FailedApiCallException,
            'some other message'
          )
        expect { subject.call(params) }
          .to raise_error SlackIntegration::FailedApiCallException, 'some other message'
      end
    end

    it 'marks onboarding step as completed' do
      allow(service).to receive(:invite).with(any_args)
      expect { subject.call(params) }
        .to change { user.developer_onboarding.reload.slack }
        .from(false).to(true)
    end
  end
end
