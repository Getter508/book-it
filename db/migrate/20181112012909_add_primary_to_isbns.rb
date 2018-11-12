class AddPrimaryToIsbns < ActiveRecord::Migration[5.2]
  def change
    add_column :isbns, :primary_number, :boolean, default: false
  end
end
