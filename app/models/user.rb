# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#  name            :string
#  admin           :boolean          default(FALSE)
#  about           :string
#

require 'sorcery/model'

# Represents any user in the system
# ATM it has `member_onboarding` association, that should be moved to some other model.
class User < ApplicationRecord
  include Rolable

  authenticates_with_sorcery!

  validates :email, presence: true, uniqueness: true

  # Member role
  has_many :user_skills
  has_many :skills, through: :user_skills
  has_many :authentications, dependent: :destroy
  has_many :votes

  # TODO: move to some other model, that represents member explicitly.
  has_one :member_onboarding, class_name: 'Member::Onboarding', dependent: :destroy
  has_many :test_task_assignments,
           class_name: 'Member::TestTaskAssignment',
           foreign_key: 'member_id',
           dependent: :destroy

  # Author role
  has_many :ideas, foreign_key: 'author_id'

  # Staff and mentor role
  has_many :approved_users, class_name: 'User', foreign_key: 'approver_id'

  has_many :notes, as: :noteable
  belongs_to :approver, class_name: 'User', optional: true

  has_many :project_users
  has_many :projects, through: :project_users

  accepts_nested_attributes_for :authentications

  scope :newer_first, -> { order(id: :desc) }

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
    Ops::Member::Onboarding::Progress.new(self).percent
  end

  def primary_skill
    skills.find_by(user_skills: { primary: true })
  end
end
