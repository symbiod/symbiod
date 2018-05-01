# frozen_string_literal: true

FactoryBot.define do
  factory :developer_test_task_result, class: 'Developer::TestTaskResult' do
    link { Faker::Internet.url }
  end
end
