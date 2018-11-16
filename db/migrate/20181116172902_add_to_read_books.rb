class AddToReadBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :to_read_books do |t|
      t.integer :book_id, null: false
      t.integer :user_id, null: false
      t.integer :rank

      t.timestamps null: false
    end

    add_index :to_read_books, :user_id
  end
end
