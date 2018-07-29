class AddStateColumnToRole < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :state, :string, index: true
  end
end
