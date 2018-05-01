# frozen_string_literal: true

FactoryBot.define do
  factory :developer_test_task_assignment, class: 'Developer::TestTaskAssignment' do
    test_task { create(:developer_test_task) }
    test_task_result { create(:developer_test_task_result) }
    developer { create(:developer) }
  end
end
