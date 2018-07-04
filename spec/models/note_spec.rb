# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :content }
  end

  describe 'relations' do
    it { is_expected.to belong_to :commenter }
    it { is_expected.to belong_to :noteable }
  end
end
