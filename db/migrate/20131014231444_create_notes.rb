class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :notebook_id
      t.string :title
      t.text :body
      t.integer :user_id
      t.timestamp :published_at

      t.timestamps
    end
  end
end
