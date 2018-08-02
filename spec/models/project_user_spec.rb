# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to :project }
    it { is_expected.to belong_to :user }
  end
end
