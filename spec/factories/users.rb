FactoryBot.define do
  factory :user, aliases: [:author, :developer] do
    email { Faker::Internet.email }
    state 'pending'
    password 'password'
    salt { 'ExqpVWiDcK2vGfeRjqTx' }
    crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt('password', salt) }

    trait :with_name do
      name { Faker::Name.name }
    end
  end
end
