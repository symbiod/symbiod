# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Developer::TestTask, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :skill_id }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_length_of(:description).is_at_least(50) }

  it { is_expected.to have_many(:test_task_assignments) }
  it { is_expected.to belong_to(:role) }
  it { is_expected.to belong_to(:skill) }
end
