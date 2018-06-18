# frozen_string_literal: true

require 'rails_helper'

describe SlackPolicy do
  subject { described_class.new(user, nil) }
  let(:role) { :mentor }

  context 'mentor user' do
    let(:user) { create(:user, :mentor) }

    it { is_expected.to permit_action(:able_to_join_channel, role) }
  end

  context 'developer user' do
    let(:user) { create(:user, :developer) }

    it { is_expected.not_to permit_action(:able_to_join_channel, role) }
  end
end
