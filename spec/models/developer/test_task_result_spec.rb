# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Developer::TestTaskResult, type: :model do
  it { is_expected.to validate_presence_of :link }
  it { is_expected.to have_one :test_task_assignment }
end
