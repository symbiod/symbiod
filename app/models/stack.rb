# frozen_string_literal: true

# == Schema Information
#
# Table name: stacks
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  identifier :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# It group of skills, that are required for project staffing.
class Stack < ApplicationRecord
  has_many :stack_skills
  has_many :skills, through: :stack_skills
  has_many :projects

  validates :name, presence: true
  validates :identifier, presence: true, uniqueness: true
end
