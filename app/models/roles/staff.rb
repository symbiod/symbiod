module Roles
  class Staff < Role
    def self.sti_name
      "Roles::Staff"
    end
  end
end
