# frozen_string_literal: true

# This model contains notes for any entity in our system
class Note < ApplicationRecord
  validates :content, presence: true
  belongs_to :noteable, polymorphic: true
  belongs_to :commenter, class_name: 'User', foreign_key: 'commenter_id'
end
