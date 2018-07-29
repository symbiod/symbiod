# frozen_string_literal: true

# Represents possible role in the system. This class has a subset of descendants,
# that represent specific roles, and may have a completely different behaviour.
# Take a look at `app/models/roles/*.rb` files for more information
class Role < ApplicationRecord
  include AASM

  belongs_to :user

  validates :type, inclusion: { in: Rolable.role_class_names }

  def name
    Roles::RolesManager.role_name_by_type(self.class)
  end
end
