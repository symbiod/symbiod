# frozen_string_literal: true

require 'rails_helper'

describe NavBarMenuHelper do
  describe '#count_applicants' do
    context 'pending applications exist' do
      let!(:candidate1) { create(:user, :developer, :screening_completed) }
      let!(:candidate2) { create(:user, :developer, :screening_completed) }
      let!(:candidate3) { create(:user, :developer, :active) }

      it 'returns positive number of pending users' do
        expect(count_applicants).to eq '(2)'
      end
    end

    context 'no pending applications' do
      it 'returns nil' do
        expect(count_applicants).to eq nil
      end
    end
  end
end
