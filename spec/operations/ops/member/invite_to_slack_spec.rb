# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::InviteToSlack do
  subject       { described_class }
  let(:user)    { create(:user, :member) }
  let(:params)  { { user: user } }
  let(:channels) { %w[bootcamp self-development feed ideas] }
  let(:service) { double }
  before { user.create_member_onboarding }

  describe '#call' do
    before do
      allow(SlackService).to receive(:new).with(any_args).and_return(service)
    end

    context 'user was not invited before' do
      context 'is mentor' do
        let(:user) { create(:user, :mentor, :active) }
        let(:channels) { %w[bootcamp self-development feed ideas mentors] }

        it 'invites member to Slack' do
          expect(service).to receive(:invite).with(user, channels)
          subject.call(params)
        end

        it 'users change slack status' do
          allow(service).to receive(:invite).with(user, channels)
          expect { subject.call(params) }.to change { user.member_onboarding.reload.slack_status }
            .from('slack_pending').to('slack_invited')
        end
      end

      context 'is member' do
        let(:user) { create(:user, :member, :active) }
        let(:channels) { %w[bootcamp self-development feed ideas] }

        it 'invites member to Slack' do
          expect(service).to receive(:invite).with(user, channels)
          subject.call(params)
        end

        it 'users change slack status' do
          allow(service).to receive(:invite).with(user, channels)
          expect { subject.call(params) }.to change { user.member_onboarding.reload.slack_status }
            .from('slack_pending').to('slack_invited')
        end
      end
    end

    context 'user was invited before' do
      it 'handles exception properly' do
        expect(service)
          .to receive(:invite)
          .with(user, channels)
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
          .with(user, channels)
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
