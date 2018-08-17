# frozen_string_literal: true

FactoryBot.define do
  factory :developer_onboarding_survey_response, class: 'Developer::Onboarding::SurveyResponse' do
    feedback 'MyString'
    jsonb 'MyString'
  end
end
