# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  idea_id    :integer          not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  stack_id   :bigint(8)
#

# This model is designed to implement the project from the idea
class Project < ApplicationRecord
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  belongs_to :idea
  has_one :author, through: :idea

  has_many :project_users
  has_many :users, through: :project_users

  belongs_to :stack
end
