class AddBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :subtitle
      t.string :genre, null: false
      t.integer :year, null: false
      t.integer :pages
      t.string :description
      t.string :cover

      t.timestamps null: false
    end
  end
end
