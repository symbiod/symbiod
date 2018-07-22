# frozen_string_literal: true

module Roles
  class Developer < Role
    def self.sti_name
      'Roles::Developer'
    end
  end
end
