# frozen_string_literal: true

# == Schema Information
#
# Table name: ideas
#
#  id                 :bigint(8)        not null, primary key
#  name               :string           not null
#  description        :text             not null
#  author_id          :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  private_project    :boolean          default(FALSE)
#  skip_bootstrapping :boolean          default(FALSE)
#  state              :string           not null
#

# It is a model of ideas that are offered by the authors
class Idea < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 500 }

  belongs_to :author, class_name: 'User'
  has_one :project

  has_many :votes

  include AASM

  aasm column: 'state' do
    state :pending, initial: true
    state :voting, :active, :disabled, :rejected

    event :voting do
      transitions from: :pending, to: :voting
    end

    event :activate do
      transitions from: %i[voting disabled], to: :active
    end

    event :reject do
      transitions from: %i[pending voting], to: :rejected
    end

    event :disable do
      transitions from: :active, to: :disabled
    end
  end
end
