# frozen_string_literal: true

# == Schema Information
#
# Table name: user_skills
#
#  id         :bigint(8)        not null, primary key
#  primary    :boolean          default(FALSE)
#  skill_id   :bigint(8)
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# This model is designed to store links between user and skill
class UserSkill < ApplicationRecord
  belongs_to :skill
  belongs_to :user
end
