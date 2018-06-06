# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name 'developer'

    factory :role_with_one_test_task do
      transient do
        test_tasks_count Ops::Developer::Screening::Start::NUMBER_OF_ASSIGNED_TEST_TASKS - 1
      end

      after(:create) do |role, evaluator|
        create_list(:developer_test_task, evaluator.test_tasks_count, role_id: role.id)
      end
    end

    factory :role_with_test_task_disabled do
      transient do
        test_tasks_count 100
      end

      after(:create) do |role, evaluator|
        create_list(:developer_test_task, evaluator.test_tasks_count, :disabled, role_id: role.id)
      end
    end

    factory :role_with_test_tasks do
      transient do
        test_tasks_count 100
      end

      after(:create) do |role, evaluator|
        create_list(:developer_test_task, evaluator.test_tasks_count, role_id: role.id)
      end
    end
  end
end
