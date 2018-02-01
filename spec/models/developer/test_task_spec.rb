require 'rails_helper'

RSpec.describe Developer::TestTask, type: :model do
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_length_of(:description).is_at_least(50) }
end
