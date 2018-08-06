# frozen_string_literal: true

FactoryBot.define do
  factory :feedback_question, class: 'Developer::Onboarding::FeedbackQuestion' do
    description { Faker::VForVendetta.quote }
    sequence(:key_name) { |n| "question_#{n}" }
  end
end
