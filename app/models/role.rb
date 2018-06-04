# frozen_string_literal: true

# The Role using to add roles users
class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles
  has_many :test_tasks, class_name: 'Developer::TestTask', dependent: :destroy

  ROLES = %w[developer staff author mentor].freeze

  belongs_to :resource, polymorphic: true, optional: true
  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true
  validates :name, inclusion: { in: Role::ROLES }

  scope :for_test_tasks, -> { where(name: %w[developer mentor]) }

  scopify
end
