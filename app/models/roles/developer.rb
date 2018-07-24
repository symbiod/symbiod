# frozen_string_literal: true

module Roles
  # Describes developer role
  class Developer < Role
    def self.sti_name
      'Roles::Developer'
    end
  end
end
