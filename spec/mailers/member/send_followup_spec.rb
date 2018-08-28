# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Member::Screening::SendFollowupMailer, type: :mailer do
  describe 'notify' do
    let(:role) { create(:role) }
    let(:mail) { Member::Screening::SendFollowupMailer.notify(role.id) }

    it 'renders the subject' do
      expect(mail.subject).to eq("#{I18n.t('dashboard.users.mailers.uncompleted.subject')}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([role.user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['givemepoc@gmail.com'])
    end
  end
end
