class User < ApplicationRecord
  ROLES = %w[ developer stuff author ]

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: User::ROLES }
end
