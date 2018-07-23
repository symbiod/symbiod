# frozen_string_literal: true

FactoryBot.define do
  factory :stack_skill do
    skill { create(:skill) }
    stack { create(:stack) }
  end
end
