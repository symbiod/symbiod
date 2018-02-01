class Developer::TestTask < ApplicationRecord
  validates :description, presence: true, length: { minimum: 50 }
end
