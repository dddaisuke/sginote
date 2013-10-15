class CreateNotebooks < ActiveRecord::Migration
  def change
    create_table :notebooks do |t|
      t.string :title
      t.integer :user_id
      t.integer :notes_count, default: 0
      t.timestamp :published_at

      t.timestamps
    end
  end
end
