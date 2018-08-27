# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Member::TestTaskAssignment, type: :model do
  it { is_expected.to belong_to :test_task }
  it { is_expected.to belong_to(:test_task_result).optional }
  it { is_expected.to belong_to :member }

  describe '#completed?' do
    context 'assignment is not completed' do
      subject { create(:member_test_task_assignment, :uncompleted) }
      its(:completed?) { is_expected.to eq false }
    end

    context 'assignment is completed' do
      subject { create(:member_test_task_assignment, :completed) }
      its(:completed?) { is_expected.to eq true }
    end
  end
end
