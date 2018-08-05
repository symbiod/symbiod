# frozen_string_literal: true

require 'rails_helper'

describe Ops::Projects::GenerateProjectSlackChannel do
  subject { described_class }
  let!(:idea) { create(:idea, :with_project) }
  let!(:service) { double }
  let!(:user) { create(:user, :developer, :active) }
  let!(:channel) { idea.project.slug }
  before { create(:project_user, project: idea.project, user: user) }

  describe '#call' do
    before do
      allow(SlackService).to receive(:new).with(any_args).and_return(service)
    end
    let!(:params) { { project: idea.project } }

    context 'create Slack channel for project' do
      it 'create channel' do
        expect(service).to receive(:create_channel).with(idea.project.slug)
        subject.call(params)
      end
    end

    context 'user was not invited before' do
      it 'invites member to Slack' do
        allow(service).to receive(:create_channel).with(any_args)
        expect(service).to receive(:invite_to_channel).with(channel, user.email)
        subject.call(params)
      end
    end

    context 'user was invited before' do
      it 'handles exception properly' do
        allow(service).to receive(:create_channel).with(any_args)
        expect(service)
          .to receive(:invite_to_channel)
          .with(channel, user.email)
          .and_raise(
            Slack::Web::Api::Errors::SlackError,
            'cant_invite_self'
          )
        subject.call(params)
      end
    end

    context 'some other exception occured' do
      it 'handles exception properly' do
        allow(service).to receive(:create_channel).with(any_args)
        allow(service)
          .to receive(:invite_to_channel)
          .with(channel, user.email)
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
