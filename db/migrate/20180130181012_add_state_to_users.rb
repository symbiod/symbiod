class AddStateToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :state, :string, index: true
  end
end
