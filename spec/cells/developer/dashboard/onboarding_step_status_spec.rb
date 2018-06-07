# frozen_string_literal: true

require 'rails_helper'

describe Developer::Dashboard::OnboardingStepStatus do
  subject { described_class }

  context 'user status invited' do
    let(:user) { create(:user) }
    before { create(:developer_onboarding, :invited_to_slack, user: user) }

    it 'renders success color' do
      expect(subject.new(user, resource: :slack).onboarding_step_status)
        .to match('class="btn btn-success btn-sm disabled"')
    end

    it 'renders status invited' do
      expect(subject.new(user, resource: :slack).onboarding_step_status)
        .to match('invited')
    end
  end

  context 'user status uninvited' do
    let(:user) { create(:user) }
    before { create(:developer_onboarding, user: user) }

    it 'renders danger color' do
      expect(subject.new(user, resource: :slack).onboarding_step_status)
        .to match('class="btn btn-danger btn-sm disabled"')
    end

    it 'renders status uninvited' do
      expect(subject.new(user, resource: :slack).onboarding_step_status).to match('uninvited')
    end
  end
end
