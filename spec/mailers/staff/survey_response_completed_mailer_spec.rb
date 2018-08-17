# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Staff::SurveyResponseCompletedMailer, type: :mailer do
  describe 'notify' do
    let(:user) { create(:user, :with_primary_skill, :with_feedback) }
    let(:mail) { Staff::SurveyResponseCompletedMailer.notify(user.id) }
    let(:recipients) { create_list(:user, 2) }

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('dashboard.survey_responses.notices.completed'))
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['givemepoc@gmail.com'])
    end

    it 'renders link to github' do
      expect(mail.body.encoded)
        .to match("<a target=\"_blank\" href=\"https://github.com/#{user_github}\">#{user_github}</a>")
    end

    it 'gets list of recipients' do
      query_object = double(call: recipients)
      expect(Users::ScreeningCompletedNotificationRecipientsQuery)
        .to receive(:new).and_return(query_object)
      expect(mail.to).to eq recipients.map(&:email)
    end
  end

  def user_github
    CGI.escapeHTML(user.github)
  end
end
