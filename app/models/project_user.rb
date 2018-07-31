# frozen_string_literal: true

# This model is designed to store links between project and user
class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
end
