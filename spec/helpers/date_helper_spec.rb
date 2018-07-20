# frozen_string_literal: true

require 'rails_helper'

describe DateHelper do
  subject(:user) { create(:user) }
  it { expect(human_date(user)).to eq user.created_at.strftime('%d-%m-%Y') }
end
