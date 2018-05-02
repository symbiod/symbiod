# frozen_string_literal: true

class PromoteUserToStuff < ActiveRecord::Migration[5.2]
  def up
    User.find_by(email: 'ejabberd@gmail.com')&.add_role(:stuff)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
