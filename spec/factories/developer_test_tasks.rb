FactoryBot.define do
  factory :developer_test_task, class: 'Developer::TestTask' do
    description { Faker::VForVendetta.speech }
  end
end
