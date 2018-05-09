class PromoteUserToStaff < ActiveRecord::Migration[5.2]
  def up
    User.find_by(email: 'ejabberd@gmail.com')&.add_role(:staff)
  end

  def down
    User.find_by(email: 'ejabberd@gmail.com')&.remove_role(:staff)
  end
end
