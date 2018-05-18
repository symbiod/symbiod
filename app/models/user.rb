# frozen_string_literal: true

require 'sorcery/model'

# Represents any user in the system
# ATM it has `developer_onboarding` association, that should be moved to some other model.
class User < ApplicationRecord
  rolify

  include AASM

  after_create :assign_default_role

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, :location, :timezone, :cv_url, presence: true

  has_many :ideas, foreign_key: 'author_id'
  has_many :authentications, dependent: :destroy

  # TODO: move to some other model, that represents developer explicitly.
  has_one :developer_onboarding, class_name: 'Developer::Onboarding', dependent: :destroy
  has_many :test_task_assignments,
           class_name: 'Developer::TestTaskAssignment',
           foreign_key: 'developer_id',
           dependent: :destroy

  accepts_nested_attributes_for :authentications

  scope :active_or_disabled, -> { where(state: %w[active disabled screening_completed]).order(id: :desc) }

  aasm column: 'state' do
    state :pending, initial: true
    state :profile_completed, :screening_completed, :active,
      :disabled, :rejected

    event :complete_profile do
      transitions from: :pending, to: :profile_completed
    end

    event :complete_screening do
      transitions from: :profile_completed, to: :screening_completed
    end

    event :activate do
      transitions from: %i[screening_completed disabled], to: :active
    end

    event :disable do
      transitions from: :active, to: :disabled
    end

    event :reject do
      transitions from: :screening_completed, to: :rejected
    end
  end

  authenticates_with_sorcery!

  def assign_default_role
    add_role(:developer) if roles.blank?
  end

  def github_uid
    authentications.github.first&.uid
  end

  def test_tasks_completed?
    test_task_assignments.where(test_task_result_id: nil).count.zero?
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
