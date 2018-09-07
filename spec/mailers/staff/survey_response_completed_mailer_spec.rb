# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Staff::SurveyResponseCompletedMailer, type: :mailer do
  subject { described_class.notify(user.id) }
  let!(:question) { create(:feedback_question) }

  describe 'notify' do
    let(:user) { create(:user, :member, :active) }
    let(:recipients) { User.with_role(:staff) }
    before do
      create(:user, :staff, :active)
      create(:survey_response, role: user.role(:member), "#{question.key_name}": 'Answer 1')
    end

    its(:subject) { is_expected.to eq I18n.t('mailers.member.onboarding.survey_responses.subject') }
    its(:from) { is_expected.to eq(['givemepoc@gmail.com']) }
    its(:to) { is_expected.to eq recipients.map(&:email) }

    it 'renders link to github' do
      expect(subject.body.encoded)
        .to match("<a target=\"_blank\" href=\"https://github.com/#{user_github}\">#{user_github}</a>")
    end
  end

  def user_github
    CGI.escapeHTML(user.github)
  end
end
