# frozen_string_literal: true

# == Schema Information
#
# Table name: votes
#
#  id         :bigint(8)        not null, primary key
#  vote_type  :string           not null
#  idea_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# This is the voting class for ideas
class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :idea

  validates :vote_type, presence: true

  scope :up, -> { where(vote_type: 'up') }
  scope :down, -> { where(vote_type: 'down') }
end
