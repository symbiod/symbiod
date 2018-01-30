FactoryBot.define do
  factory :developer_test_task_result, class: 'Developer::TestTaskResult' do
    link { Faker::Internet.url }
    developer
    test_task { create(:developer_test_task) }
  end
end
