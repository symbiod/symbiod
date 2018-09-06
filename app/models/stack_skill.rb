# frozen_string_literal: true

# == Schema Information
#
# Table name: stack_skills
#
#  id         :bigint(8)        not null, primary key
#  stack_id   :bigint(8)
#  skill_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# This model is designed to stroe links between skill and stack
class StackSkill < ApplicationRecord
  belongs_to :skill
  belongs_to :stack
end
