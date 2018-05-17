class AddProfileFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    # TODO: add not_null
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :location, :string
    add_column :users, :timezone, :string
    add_column :users, :cv_url, :string
  end
end
