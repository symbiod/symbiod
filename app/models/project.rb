# frozen_string_literal: true

# This model is designed to implement the project from the idea
class Project < ApplicationRecord
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  belongs_to :idea

  has_many :project_users
  has_many :users, through: :project_users

  belongs_to :stack
end
