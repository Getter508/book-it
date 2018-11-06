class GenreModifications < ActiveRecord::Migration[5.2]
  def up
    remove_column :books, :genre, :string, null: false

    create_table :genres do |t|
      t.string :name, null: false, unique: true
      t.timestamps null: false
    end

    create_table :book_genres do |t|
      t.integer :book_id
      t.integer :genre_id
      t.timestamps null: false
    end
    add_index :book_genres, :genre_id
    add_index :book_genres, :book_id
  end

  def down
    add_column :books, :genre, :string, null: false
    remove_index :book_genres, :genre_id
    remove_index :book_genres, :book_id
    drop_table :genres
    drop_table :book_genres
  end
end
