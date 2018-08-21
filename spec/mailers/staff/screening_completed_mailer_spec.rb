# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Staff::ScreeningCompletedMailer, type: :mailer do
  describe 'notify' do
    subject { Staff::ScreeningCompletedMailer.notify(user.id) }
    let(:user) { create(:user, :with_primary_skill) }
    let(:recipients) { create_list(:user, 2) }

    its(:subject) { is_expected.to eq("#{I18n.t('bootcamp.screening.completed')}, #{user.full_name}") }
    its(:from) { is_expected.to eq([Settings.notifications.email.default_from]) }

    describe '#to' do
      before do
        query_object = double(call: recipients)
        expect(Users::ScreeningCompletedNotificationRecipientsQuery)
          .to receive(:new).and_return(query_object)
      end

      its(:to) { is_expected.to eq recipients.map(&:email) }

      it 'renders link to github' do
        expect(subject.body.encoded)
          .to match("<a target=\"_blank\" href=\"https://github.com/#{user_github}\">#{user_github}</a>")
      end
    end
  end

  def user_github
    CGI.escapeHTML(user.github)
  end
end
