# frozen_string_literal: true

require 'rails_helper'

describe Dashboard::FeedbackQuestionPolicy do
  subject { described_class.new(user, nil) }

  context 'user has role staff' do
    let(:user) { create(:user, :staff, :active) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'user has role not staff' do
    let(:user) { create(:user, :without_an_staff, :active) }

    it { is_expected.not_to permit_action(:index) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:destroy) }
  end
end
