# frozen_string_literal: true

# == Schema Information
#
# Table name: project_users
#
#  id         :bigint(8)        not null, primary key
#  project_id :bigint(8)
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  mentor     :boolean          default(FALSE)
#

# This model is designed to store links between project and user
class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
end
