# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Skill, type: :model do
  subject(:skill) { create(:skill) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_uniqueness_of :title }
  end
end
