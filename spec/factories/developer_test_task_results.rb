# frozen_string_literal: true

FactoryBot.define do
  factory :member_test_task_result, class: 'Member::TestTaskResult' do
    link { Faker::Internet.url }
  end
end
