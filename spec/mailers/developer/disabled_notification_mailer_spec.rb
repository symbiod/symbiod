# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Developer::DisabledNotificationMailer, type: :mailer do
  describe '#notify' do
    subject { Developer::DisabledNotificationMailer.notify(user.id) }
    let(:user) { create(:user) }

    its(:subject) { is_expected.to eq I18n.t('dashboard.users.mailers.disabled.subject') }
    its(:to) { is_expected.to eq [user.email] }
    its(:from) { is_expected.to eq [Settings.notifications.email.default_from] }
  end
end
