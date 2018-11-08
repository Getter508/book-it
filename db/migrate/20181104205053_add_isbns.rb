class AddIsbns < ActiveRecord::Migration[5.2]
  def change
    create_table :isbns do |t|
      t.integer :book_id, null: false
      t.integer :isbn, null: false, unique: true

      t.timestamps null: false
    end

    add_index :isbns, :book_id 
  end
end
