# frozen_string_literal: true

FactoryBot.define do
  factory :survey_response, class: 'Developer::Onboarding::SurveyResponse' do
    feedback { { question_1: Faker::VForVendetta.speech, question_2: Faker::VForVendetta.speech } }
    user
  end
end
