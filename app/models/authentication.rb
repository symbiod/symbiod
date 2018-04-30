# frozen_string_literal: true

# Holds all authentications made through OAuth providers
class Authentication < ApplicationRecord
  scope :github, -> { where(provider: 'github') }
end
