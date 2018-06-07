# frozen_string_literal: true

require 'yaml'

FactoryBot.define do
  skills = YAML.load_file('data/skills.yml')

  factory :skill do
    title skills.sample
  end
end
