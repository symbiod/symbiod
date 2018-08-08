require "rails_helper"

RSpec.describe Author::RoleActivatedMailer, type: :mailer do
  describe '#notify' do
    subject { described_class.notify(author.id) }
    let(:author) { create(:role, :author) }

    its(:subject) { is_expected.to eq I18n.t('idea.wizard.mailers.activated.subject') }
    its(:to) { is_expected.to eq [author.user.email] }
    its(:from) { is_expected.to eq [Settings.notifications.email.default_from] }
  end
end
