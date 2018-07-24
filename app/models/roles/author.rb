# frozen_string_literal: true

module Roles
  # Describes author role
  class Author < Role
    def self.sti_name
      'Roles::Author'
    end
  end
end
