# frozen_string_literal: true

# == Schema Information
#
# Table name: notes
#
#  id            :bigint(8)        not null, primary key
#  content       :text
#  noteable_id   :integer
#  noteable_type :string
#  commenter_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# This model contains notes for any entity in our system
class Note < ApplicationRecord
  validates :content, presence: true
  belongs_to :noteable, polymorphic: true
  belongs_to :commenter, class_name: 'User', foreign_key: 'commenter_id'
end
