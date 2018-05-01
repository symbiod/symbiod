# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Developer::TestTaskAssignment, type: :model do
  it { is_expected.to belong_to :test_task }
  it { is_expected.to belong_to :test_task_result }
  it { is_expected.to belong_to :developer }
end
