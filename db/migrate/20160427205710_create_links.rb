class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text :full_url, null: false
      t.string :short_url, null: false
      t.references :user, foreign_key: true, index: true

      t.timestamps null: false
    end
    add_index :links, :short_url, unique: true
  end
end
