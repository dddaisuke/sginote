class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.string :body
      t.integer :user_id
      t.timestamp :published_at

      t.timestamps
    end
  end
end
