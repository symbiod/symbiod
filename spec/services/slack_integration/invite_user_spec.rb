# frozen_string_literal: true

require 'rails_helper'
require './app/services/slack_integration/invite_user'

describe SlackIntegration::InviteUser do
  subject { described_class.new(attributes) }
  let(:attributes) do
    {
      user:  user,
      token: token
    }
  end
  let(:user) { create(:user, :slack_user) }
  let(:token) { '1234567890' }

  describe '#call' do
    context 'valid params' do
      slack_success_response!

      it 'does not raise error' do
        expect { subject.call }.not_to raise_error
      end
    end

    context 'invalid params' do
      slack_failed_response!

      it 'raises error' do
        expect { subject.call }.to raise_error SlackIntegration::FailedApiCallException
      end
    end

    context 'user already exists in team' do
      slack_user_already_exists!

      it 'does not raise error' do
        expect { subject.call }.not_to raise_error
      end
    end

    context 'user mentor' do
      slack_success_response_mentor!
      let!(:user) { create(:user, :slack_user, :mentor) }

      it 'add channel mentor' do
        expect { subject.call }.not_to raise_error
      end
    end
  end
end
