FactoryBot.define do
  factory :idea do
    name { Faker::Company.bs }
    description { Faker::HowIMetYourMother.quote }
    private [false, true].sample
    skip_bootstrapping [false, true].sample
    author
  end
end
