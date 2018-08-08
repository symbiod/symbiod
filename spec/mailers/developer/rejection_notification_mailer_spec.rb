# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Developer::RejectionNotificationMailer, type: :mailer do
  describe 'notify' do
    let(:user) { create(:user) }
    subject { Developer::RejectionNotificationMailer.notify(user.id, 'feedback') }

    its(:subject) { is_expected.to eq("#{I18n.t('bootcamp.screening.rejection')}, #{user.full_name}") }
    its(:to) { is_expected.to eq([user.email]) }
    its(:from) { is_expected.to eq([Settings.notifications.email.default_from]) }
  end
end
