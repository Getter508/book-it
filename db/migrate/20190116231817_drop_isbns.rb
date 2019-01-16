class DropIsbns < ActiveRecord::Migration[5.2]
  def up
    drop_table :isbns
  end

  def down
    create_table :isbns do |t|
      t.integer :book_id, null: false
      t.string :international_standard_book_number, null: false, unique: true
      t.boolean :primary_number, default: false

      t.timestamps null: false
    end

    add_index :isbns, :book_id
  end
end
