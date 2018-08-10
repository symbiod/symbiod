require "rails_helper"

RSpec.describe Developer::SendFollowupMailer, type: :mailer do
  describe 'notify' do
    let(:user) { create(:user) }
    let(:mail) { Developer::SendFollowupMailer.notify(user.id) }

    it 'renders the subject' do
      expect(mail.subject).to eq("Uncompleted screening")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['givemepoc@gmail.com'])
    end
  end
end
