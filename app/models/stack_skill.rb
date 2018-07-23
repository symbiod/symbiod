# frozen_string_literal: true

# This model is designed to stroe links between skill and stack
class StackSkill < ApplicationRecord
  belongs_to :skill
  belongs_to :stack
end
