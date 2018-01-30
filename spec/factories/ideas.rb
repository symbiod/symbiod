FactoryBot.define do
  factory :idea do
    name { Faker::Company.bs }
    description { Faker::VForVendetta.speech }
    author
  end
end
