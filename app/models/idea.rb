class Idea < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true

  belongs_to :author, class_name: 'User'
  has_one :project
end
