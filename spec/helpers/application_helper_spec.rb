# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  context 'pending applications exist' do
    let!(:candidate1) { create(:user, :developer, :screening_completed) }
    let!(:candidate2) { create(:user, :developer, :screening_completed) }
    let!(:candidate3) { create(:user, :developer, :active) }

    it 'returns positive number of pending users' do
      expect(count_of_pending_users).to eq '(2)'
    end
  end

  context 'no pending applications' do
    it 'returns nil' do
      expect(count_of_pending_users).to eq nil
    end
  end
end
