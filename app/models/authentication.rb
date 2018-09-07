# frozen_string_literal: true

# == Schema Information
#
# Table name: authentications
#
#  id         :bigint(8)        not null, primary key
#  user_id    :integer          not null
#  provider   :string           not null
#  uid        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Holds all authentications made through OAuth providers
class Authentication < ApplicationRecord
  belongs_to :user

  scope :github, -> { where(provider: 'github') }
end
