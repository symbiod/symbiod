# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: %i[author developer] do
    email { Faker::Internet.email }
    state 'pending'
    password 'password'
    salt { 'ExqpVWiDcK2vGfeRjqTx' }
    crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt('password', salt) }

    trait :with_name do
      name { Faker::Name.name }
    end

    trait :active do
      state 'active'
    end

    trait :staff do
      after(:create) do |user|
        user.add_role(:stuff)
      end
    end
  end
end
