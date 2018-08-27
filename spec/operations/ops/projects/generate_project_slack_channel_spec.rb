# frozen_string_literal: true

require 'rails_helper'

describe Ops::Projects::GenerateProjectSlackChannel do
  subject { described_class }
  let!(:idea) { create(:idea, :with_project) }
  let!(:service) { double }
  let!(:channel) { idea.project.slug }
  let(:author) { idea.project.author }
  let!(:user) { create(:user, :member, :active) }
  before { idea.project.users << user }

  describe '#call' do
    let!(:params) { { project: idea.project } }

    before do
      allow(SlackService).to receive(:new).with(any_args).and_return(service)
    end

    it 'creates channel' do
      expect(service).to receive(:create_channel).with(idea.project.slug)
      allow(service).to receive(:invite_to_channel).with(any_args)
      subject.call(params)
    end

    it 'invites member to Slack' do
      allow(service).to receive(:create_channel).with(any_args)
      expect(service).to receive(:invite_to_channel).with(channel, user.email)
      expect(service).to receive(:invite_to_channel).with(channel, author.email)
      subject.call(params)
    end
  end
end
