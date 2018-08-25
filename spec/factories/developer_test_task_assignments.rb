# frozen_string_literal: true

FactoryBot.define do
  factory :member_test_task_assignment, class: 'Member::TestTaskAssignment' do
    test_task { create(:member_test_task) }
    test_task_result { create(:member_test_task_result) }
    member { create(:member) }

    trait :uncompleted do
      test_task_result_id nil
    end

    trait :completed do
      test_task_result { create(:member_test_task_result) }
    end
  end
end
