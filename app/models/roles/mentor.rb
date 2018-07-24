# frozen_string_literal: true

module Roles
  # Describes mentor role
  class Mentor < Role
    def self.sti_name
      'Roles::Mentor'
    end
  end
end
