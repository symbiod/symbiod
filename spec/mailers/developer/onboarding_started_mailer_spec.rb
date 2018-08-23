# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Developer::OnboardingStartedMailer, type: :mailer do
  describe 'notify' do
    subject { Developer::OnboardingStartedMailer.notify(user.id) }
    let(:user) { create(:user) }

    its(:subject) { is_expected.to eq("#{I18n.t('bootcamp.onboarding.started')}, #{user.full_name}") }
    its(:to) { is_expected.to eq([user.email]) }
    its(:from) { is_expected.to eq([Settings.notifications.email.default_from]) }
  end
end
