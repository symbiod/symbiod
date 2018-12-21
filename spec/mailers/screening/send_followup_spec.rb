# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Screening::SendFollowupMailer, type: :mailer do
  describe 'notify' do
    let(:role) { create(:role) }
    let(:mail) { Screening::SendFollowupMailer.notify(role.id) }

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('dashboard.users.mailers.uncompleted.subject').to_s)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([role.user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['symbiod@gmail.com'])
    end
  end
end
