FactoryBot.define do
  factory :project do
    name { Faker::Company.name }
    slug { Faker::Internet.slug }
    idea
  end
end
