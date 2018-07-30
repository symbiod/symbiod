# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  let!(:candidate1) { create(:user, :screening_completed) }
  let!(:candidate2) { create(:user, :screening_completed) }

  it 'return coun of pending users' do
    expect(count_of_pending_users).to eq '(2)'
  end
end
