# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Developer::TestTask, type: :model do
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_length_of(:description).is_at_least(50) }
  it { is_expected.to have_many(:test_task_results) }
end
