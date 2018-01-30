require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    subject { create :project }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :slug }
    it { is_expected.to validate_uniqueness_of :slug }
  end

  it { is_expected.to belong_to :idea }
end
