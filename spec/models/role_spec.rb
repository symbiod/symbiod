# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'validations' do
    subject { build(:role) }

    it { is_expected.to validate_inclusion_of(:type).in_array(Rolable.role_class_names) }
  end
end
