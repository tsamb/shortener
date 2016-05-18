class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text :full_url, null: false
      t.string :short_url, null: false, index: true, unique: true
      t.references :user, foreign_key: true, index: true

      t.timestamps null: false
    end
  end
end
