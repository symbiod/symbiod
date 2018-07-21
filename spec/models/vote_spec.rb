# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :vote_type }
  end

  describe 'relations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :idea }
  end
end
