class RemoveUserAdminNullConstraint < ActiveRecord::Migration[5.2]
  def up
    remove_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :admin, :boolean, default: false
  end

  def down
    remove_column :users, :admin, :boolean, default: false
    add_column :users, :admin, :boolean, null: false, default: false
  end
end
