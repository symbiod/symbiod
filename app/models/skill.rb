# frozen_string_literal: true

# This model contains a list of possible developer skills
class Skill < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
