# frozen_string_literal: true

require 'rails_helper'

describe Web::Dashboard::OnboardingStepStatus do
  subject { described_class.new(user, resource: :slack_status).onboarding_step_status }

  context 'resource status is invited' do
    let(:user) { create(:user) }
    before { create(:member_onboarding, :invited_to_slack, user: user) }

    it 'renders warning color' do
      expect(subject).to match('class="btn btn-warning btn-sm disabled"')
    end

    it 'renders status invited' do
      expect(subject).to match('invited')
    end
  end

  context 'resource status is pending' do
    let(:user) { create(:user) }
    before { create(:member_onboarding, user: user) }

    it_behaves_like 'button status is pending'
  end

  context 'resource status is joined' do
    let(:user) { create(:user) }
    before { create(:member_onboarding, :joined_to_slack, user: user) }

    it 'renders success color' do
      expect(subject).to match('class="btn btn-success btn-sm disabled"')
    end

    it 'renders status joined' do
      expect(subject).to match('joined')
    end
  end

  context 'resource status is left' do
    let(:user) { create(:user) }
    before { create(:member_onboarding, :left_slack, user: user) }

    it 'renders danger color' do
      expect(subject).to match('class="btn btn-danger btn-sm disabled"')
    end

    it 'renders status left' do
      expect(subject).to match('left')
    end
  end

  context 'user status feedback completed' do
    let(:user) { create(:user) }
    before { create(:member_onboarding, :feedback_completed, user: user) }

    it 'renders success color' do
      expect(described_class.new(user, resource: :feedback_status).onboarding_step_status)
        .to match('class="btn btn-success btn-sm disabled"')
    end

    it 'renders status completed' do
      expect(described_class.new(user, resource: :feedback_status).onboarding_step_status).to match('completed')
    end
  end
end
