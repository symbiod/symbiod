# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StackSkill, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to :skill }
    it { is_expected.to belong_to :stack }
  end
end
