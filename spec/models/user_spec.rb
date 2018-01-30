require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { create(:user) }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
    it { is_expected.to validate_presence_of :role }
    it { is_expected.to validate_inclusion_of(:role).in_array(User::ROLES) }
  end

  it { is_expected.to have_many :ideas }
end
