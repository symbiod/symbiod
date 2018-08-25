# frozen_string_literal: true

# Acts as a namespace for all classes, that belong to the Member domain
module Member
  def self.table_name_prefix
    'member_'
  end
end
