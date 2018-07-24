# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    type 'Roles::Developer'
    user
  end
end
