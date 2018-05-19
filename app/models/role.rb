# frozen_string_literal: true

# The Role using to add roles users
class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles

  ROLES = %w[developer staff author].freeze

  belongs_to :resource, polymorphic: true, optional: true
  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true
  validates :name, inclusion: { in: Role::ROLES }

  scopify
end
