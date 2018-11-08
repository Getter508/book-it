class UpdateIsbns < ActiveRecord::Migration[5.2]
  def up
    remove_column :isbns, :isbn, :integer, null: false, unique: true
    add_column :isbns, :international_standard_book_number, :string, null: false, unique: true
  end

  def down
    remove_column :isbns, :international_standard_book_number, :string, null: false, unique: true
    add_column :isbns, :isbn, :integer, null: false, unique: true
  end
end
