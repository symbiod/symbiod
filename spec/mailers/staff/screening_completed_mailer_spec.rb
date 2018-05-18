# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Staff::ScreeningCompletedMailer, type: :mailer do
  describe 'notify' do
    let(:user) { create(:user) }
    let(:mail) { Staff::ScreeningCompletedMailer.notify(user) }

    it 'renders the subject' do
      expect(mail.subject).to eq("#{I18n.t('bootcamp.screening.completed')}, #{user.full_name}")
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['givemepoc@gmail.com'])
    end
  end
end
