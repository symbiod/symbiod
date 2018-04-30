class Authentication < ApplicationRecord
  scope :github, -> { where(provider: 'github') }
end
