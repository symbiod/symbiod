# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Staff::ScreeningCompletedMailer, type: :mailer do
  describe 'notify' do
    let(:user) { create(:user, :with_primary_skill) }
    let(:mail) { Staff::ScreeningCompletedMailer.notify(user.id) }
    let(:recipients) { create_list(:user, 2) }

    it 'renders the subject' do
      expect(mail.subject).to eq("#{I18n.t('bootcamp.screening.completed')}, #{user.full_name}")
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['givemepoc@gmail.com'])
    end

    it 'gets list of recipients' do
      query_object = double(call: recipients)
      expect(Users::ScreeningCompletedNotificationRecipientsQuery)
        .to receive(:new).and_return(query_object)
      expect(mail.to).to eq recipients.map(&:email)
    end
  end
end
