class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :hash
      t.integer :count, default: 0

      t.timestamps null: false
    end
  end
end
