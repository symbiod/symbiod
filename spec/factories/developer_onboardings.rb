FactoryBot.define do
  factory :developer_onboarding, class: 'Developer::Onboarding' do
    user_id 1
    slack false
    github false
  end
end
