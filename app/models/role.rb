# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id                           :bigint(8)        not null, primary key
#  type                         :string
#  user_id                      :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  state                        :string
#  last_screening_followup_date         :datetime
#  last_not_finished_survey_followup_date_at :datetime
#  unfinished_survey_followup_counter   :integer
#

# Represents possible role in the system. This class has a subset of descendants,
# that represent specific roles, and may have a completely different behaviour.
# Take a look at `app/models/roles/*.rb` files for more information
class Role < ApplicationRecord
  include AASM

  belongs_to :user

  validates :type, inclusion: { in: Rolable.role_class_names }

  def name
    Roles::RolesManager.role_name_by_type(self.class)
  end

  def is?(role_name)
    name == role_name.to_s
  end

  def set_last_screening_followup_date
    touch(:last_screening_followup_date)
  end

  def last_not_finished_survey_followup_date
    touch(:last_not_finished_survey_followup_date_at)
  end

  def increase_survey_followup_counter
    increment!(:unfinished_survey_followup_counter)
  end
end
