class AddHaveReadBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :have_read_books do |t|
      t.integer :book_id, null: false
      t.integer :user_id, null: false
      t.datetime :date_completed

      t.timestamps null: false
    end

    add_index :have_read_books, :user_id
  end
end
