# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stack, type: :model do
  subject(:stack) { create(:stack) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :identifier }
    it { is_expected.to validate_uniqueness_of :identifier }
  end

  describe 'relations' do
    it { is_expected.to have_many :skills }
    it { is_expected.to have_many :stack_skills }
  end
end
