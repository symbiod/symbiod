# frozen_string_literal: true

# This model is designed to store links between user and skill
class UserSkill < ApplicationRecord
  belongs_to :skill
  belongs_to :user
end
