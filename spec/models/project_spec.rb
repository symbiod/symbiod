# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    subject { create :project }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :slug }
    it { is_expected.to validate_uniqueness_of :slug }
  end

  describe 'relations' do
    it { is_expected.to belong_to :idea }
    it { is_expected.to belong_to :stack }
    it { is_expected.to have_many :project_users }
    it { is_expected.to have_many :users }
  end
end
