# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Developer::OnboardingStartedMailer, type: :mailer do
  describe 'notify' do
    let(:user) { create(:user) }
    let(:mail) { Developer::OnboardingStartedMailer.notify(user) }

    it 'renders the subject' do
      expect(mail.subject).to eq("#{I18n.t('bootcamp.onboarding.started')}, #{user.full_name}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['givemepoc@gmail.com'])
    end
  end
end
