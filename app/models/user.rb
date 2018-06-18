# frozen_string_literal: true

require 'sorcery/model'

# Represents any user in the system
# ATM it has `developer_onboarding` association, that should be moved to some other model.
class User < ApplicationRecord
  rolify

  include AASM

  # TODO: move to form object
  attr_accessor :role, :primary_skill_id

  # TODO: bad naming, not clear what it does
  ROLES = %w[developer mentor].freeze

  # TODO: extract all validations to form
  validates :email, presence: true, uniqueness: true
  # TODO: move cv_url validation to form object
  validates :first_name, :last_name, :location, :timezone, presence: true
  validates :role, inclusion: { in: User::ROLES }, allow_nil: true

  has_many :user_skills
  has_many :skills, through: :user_skills

  has_many :ideas, foreign_key: 'author_id'
  has_many :authentications, dependent: :destroy

  # TODO: move to some other model, that represents developer explicitly.
  has_one :developer_onboarding, class_name: 'Developer::Onboarding', dependent: :destroy
  has_many :test_task_assignments,
           class_name: 'Developer::TestTaskAssignment',
           foreign_key: 'developer_id',
           dependent: :destroy

  accepts_nested_attributes_for :authentications

  scope :newer_first, -> { order(id: :desc) }

  aasm column: 'state' do
    state :pending, initial: true
    state :policy_accepted, :profile_completed, :screening_completed, :active,
          :disabled, :rejected

    event :accept_policy do
      transitions from: :pending, to: :policy_accepted
    end

    event :complete_profile do
      transitions from: :policy_accepted, to: :profile_completed
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

  def github_uid
    authentications.github.first&.uid
  end

  def test_tasks_completed?
    test_task_assignments.where(test_task_result_id: nil).count.zero?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def progress
    Ops::Developer::OnboardingProgress.new(self).percent
  end

  def primary_skill
    skills.find_by(user_skills: { primary: true })
  end
end
