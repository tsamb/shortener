class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :user_agent
      t.string :accept_language
      t.string :path
      t.references :link, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
