# frozen_string_literal: true

require 'rails_helper'
require 'slack'
require './app/services/slack_integration/invite_user'
require './app/services/slack_service'

describe SlackService do
  subject { described_class.new(token, slack_config) }
  let(:token) { '123456' }
  let(:slack_config) { Settings.slack }
  let(:channels) { %w[channel1 channel2 channel3] }

  describe '#invite' do
    let(:user) { create(:user) }
    let(:client) { double }
    let(:result_channels) { '1,2,3' }
    let(:channels_data) do
      { 'channels' => [
        { 'id' => '1', 'name' => 'channel1' },
        { 'id' => '2', 'name' => 'channel2' },
        { 'id' => '3', 'name' => 'channel3' }
      ] }
    end

    before do
      allow_any_instance_of(described_class).to receive(:client).and_return(client)
      allow(client).to receive(:conversations_list).and_return(channels_data)
    end

    it 'calls SlackIntegration::InviteUser class' do
      invite_service = double
      allow(invite_service).to receive(:call)
      allow(SlackIntegration::InviteUser).to receive(:new)
        .with(user: user, channels: result_channels, token: token)
        .and_return(invite_service)
      subject.invite(user, channels)
    end
  end

  describe 'slack gem wrappers' do
    let(:client) { double }

    before { allow_any_instance_of(described_class).to receive(:client).and_return(client) }

    describe '#post_to_channel' do
      let(:channel) { 'channel' }
      let(:message) { 'message' }
      let(:username) { double }

      it 'calls postMessage method' do
        expect(client).to receive(:chat_postMessage)
          .with(channel: channel, text: message, as_user: false, username: slack_config.bot_name)
          .once
        subject.post_to_channel(channel, message)
      end
    end

    describe '#invite_to_channel' do
      let(:channel) { 'channel' }
      let(:email)   { 'email' }
      let(:users_data) do
        { 'members' => [
          { 'id' => '1', 'profile' => { 'email' => 'email1' } },
          { 'id' => '2', 'profile' => { 'email' => 'email' } }
        ] }
      end

      let(:channels_data) do
        { 'channels' => [
          { 'id' => '1', 'name' => 'channel1' },
          { 'id' => '2', 'name' => 'channel' }
        ] }
      end

      before do
        allow(client).to receive(:conversations_list).and_return(channels_data)
        allow(client).to receive(:users_list).and_return(users_data)
      end

      context 'channel and user exists' do
        it 'calls coversations_invite with proper args' do
          expect(client).to receive(:conversations_invite).with(channel: '2', users: '2').once
          subject.invite_to_channel(channel, email)
        end
      end

      context 'user does not exist in slack' do
        let(:users_data) do
          { 'members' => [
            { 'id' => '1', 'profile' => { 'email' => 'email1' } }
          ] }
        end

        let(:channels_data) do
          { 'channels' => [
            { 'id' => '1', 'name' => 'channel1' },
            { 'id' => '2', 'name' => 'channel' }
          ] }
        end

        it 'raises error' do
          expect { subject.invite_to_channel(channel, email) }.to raise_error(SlackIntegration::FailedApiCallException)
        end
      end

      context 'channel does not exist in slack' do
        let(:users_data) do
          { 'members' => [
            { 'id' => '1', 'profile' => { 'email' => 'email1' } },
            { 'id' => '2', 'profile' => { 'email' => 'email' } }
          ] }
        end

        let(:channels_data) do
          { 'channels' => [
            { 'id' => '1', 'name' => 'channel1' }
          ] }
        end

        it 'raises error' do
          expect { subject.invite_to_channel(channel, email) }.to raise_error(SlackIntegration::FailedApiCallException)
        end
      end

      context 'user already joined channel' do
        it 'does not raise error' do
          allow(client)
            .to receive(:conversations_invite)
            .with(any_args)
            .and_raise(
              Slack::Web::Api::Errors::SlackError,
              'cant_invite_self'
            )
          expect { subject.invite_to_channel(channel, email) }.not_to raise_error
        end
      end

      context 'other error occures during invitation' do
        it 'reraises error' do
          allow(client)
            .to receive(:conversations_invite)
            .with(any_args)
            .and_raise(
              Slack::Web::Api::Errors::SlackError,
              'some_other_error'
            )
          expect { subject.invite_to_channel(channel, email) }.to raise_error(Slack::Web::Api::Errors::SlackError)
        end
      end
    end

    describe '#create_channel' do
      let(:channel) { 'channel' }

      it 'calls conversations_create' do
        expect(client).to receive(:conversations_create)
          .with(name: channel, is_private: false)
          .once
        subject.create_channel(channel)
      end
    end
  end
end
