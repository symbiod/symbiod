# frozen_string_literal: true

require 'rails_helper'

describe DateHelper do
  subject(:user) { create(:user) }
  it { expect(reg_date(user)).to eq Time.now.utc.strftime('%d-%m-%Y') }
end
