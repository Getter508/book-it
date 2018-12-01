class AddHaveReadRatingAndNote < ActiveRecord::Migration[5.2]
  def change
    add_column :have_read_books, :rating, :integer
    add_column :have_read_books, :note, :string
  end
end
