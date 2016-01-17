class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :accesstoken, :string
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :nickname, :string
    add_column :users, :image, :string
    change_column :users, :email, :string, null: true
  end
end
