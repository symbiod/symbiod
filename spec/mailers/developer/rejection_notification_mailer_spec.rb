# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Developer::RejectionNotificationMailer, type: :mailer do
  describe 'notify' do
    let(:user) { create(:user) }
    let(:mail) { Developer::RejectionNotificationMailer.notify(user.id, 'feedback') }

    it 'renders the subject' do
      expect(mail.subject).to eq("#{I18n.t('bootcamp.screening.rejection')}, #{user.full_name}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [user.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq [Settings.email]
    end
  end
end
