# frozen_string_literal: true

require 'spec_helper'
require './app/services/slack_integration/invite_user'

describe SlackIntegration::InviteUser do
  subject { described_class.new(attributes) }
  let(:attributes) do
    {
      email:      email,
      first_name: first_name,
      last_name:  last_name,
      token:      token
    }
  end
  let(:email) { 'user@test.com' }
  let(:first_name) { 'User' }
  let(:last_name) { 'Last' }
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
  end
end
