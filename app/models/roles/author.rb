module Roles
  class Author < Role
    def self.sti_name
      "Roles::Author"
    end
  end
end
