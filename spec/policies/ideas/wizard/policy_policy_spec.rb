# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ideas::Wizard::PolicyPolicy do
  subject { described_class.new(user, nil) }

  context 'author is pending' do
    let(:user) { create(:user, :author, :pending) }
    it { is_expected.to permit_action(:authorized) }
  end

  context 'author has non-pending state' do
    let(:user) { create(:user, :author, :active) }
    it { is_expected.not_to permit_action(:authorized) }
  end
end
