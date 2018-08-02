# frozen_string_literal: true

FactoryBot.define do
  factory :project_user do
    project
    user
  end
end
