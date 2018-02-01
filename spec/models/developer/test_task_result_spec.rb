require 'rails_helper'

RSpec.describe Developer::TestTaskResult, type: :model do
  it { is_expected.to validate_presence_of :link }
  it { is_expected.to belong_to :developer }
  it { is_expected.to belong_to :test_task }
end
