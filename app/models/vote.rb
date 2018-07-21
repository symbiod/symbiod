# frozen_string_literal: true

# This is the voting class for ideas
class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :idea

  validates :vote_type, presence: true

  scope :up, -> { where(vote_type: 'up') }
  scope :down, -> { where(vote_type: 'down') }
end
