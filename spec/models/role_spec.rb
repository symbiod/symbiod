# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'validations' do
    subject { create(:role) }

    it { is_expected.to validate_inclusion_of(:name).in_array(%w[developer staff author mentor]) }
  end
end
