# frozen_string_literal: true

require 'rails_helper'

describe Developer::Dashboard::OnboardingStep do
  subject { described_class }

  context 'user status invited' do
    let(:user) { create(:user) }
    before { create(:developer_onboarding, :slack_invited, user: user) }

    it 'renders success color' do
      expect(subject.new(user, resource: :slack).status_onboarding_step).to match('class="btn btn-success btn-sm"')
    end

    it 'renders status invited' do
      expect(subject.new(user, resource: :slack).status_onboarding_step).to match('invited')
    end
  end

  context 'user status uninvited' do
    let(:user) { create(:user) }
    before { create(:developer_onboarding, user: user) }

    it 'renders danger color' do
      expect(subject.new(user, resource: :slack).status_onboarding_step).to match('class="btn btn-danger btn-sm"')
    end

    it 'renders status uninvited' do
      expect(subject.new(user, resource: :slack).status_onboarding_step).to match('uninvited')
    end
  end
end
