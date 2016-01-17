class CreateUserHashtags < ActiveRecord::Migration
  def change
    create_table :user_hashtags do |t|
      t.references :user, index: true
      t.references :hashtag, index: true

      t.timestamps null: false
    end
    add_foreign_key :user_hashtags, :users
    add_foreign_key :user_hashtags, :hashtags
  end
end
