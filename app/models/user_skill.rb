# frozen_string_literal: true

# This model is designed to store links between user and skilll
class UserSkill < ApplicationRecord
  belongs_to :skill
  belongs_to :user

  accepts_nested_attributes_for :skill
  accepts_nested_attributes_for :user
end
