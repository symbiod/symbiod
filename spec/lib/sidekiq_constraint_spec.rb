# frozen_string_literal: true

require 'rails_helper'

describe SidekiqConstraint do
  subject { SidekiqConstraint.new }
  let(:request) { double(session: { user_id: user_id }) }

  describe '#matches?' do
    context 'user is authenticated' do
      let(:user) { create(:user) }
      let(:user_id) { user.id }

      context 'user is staff' do
        before { user.add_role :staff }
        specify { expect(subject.matches?(request)).to eq true }
      end

      context 'user is not staff' do
        specify { expect(subject.matches?(request)).to eq false }
      end
    end

    context 'user is not authenticated' do
      let(:user_id) { nil }
      specify { expect(subject.matches?(request)).to eq false }
    end
  end
end
