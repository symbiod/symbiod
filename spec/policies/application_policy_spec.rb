# frozen_string_literal: true

require 'rails_helper'

describe ApplicationPolicy do
  subject { described_class.new(user, user) }
  let(:user) { create(:user) }

  it { is_expected.not_to permit_action(:index) }
  it { is_expected.not_to permit_action(:create) }
  it { is_expected.not_to permit_action(:new) }
  it { is_expected.not_to permit_action(:update) }
  it { is_expected.not_to permit_action(:edit) }
  it { is_expected.not_to permit_action(:destroy) }
end
