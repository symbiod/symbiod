require 'rails_helper'

RSpec.describe Idea, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to belong_to :author }
  it { is_expected.to have_one :project }
end
