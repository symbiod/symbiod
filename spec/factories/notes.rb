# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    content { Faker::VForVendetta.speech }
    commenter { create(:user) }
    noteable { create(:user) }
  end
end
