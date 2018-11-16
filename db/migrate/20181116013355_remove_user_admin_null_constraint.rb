class RemoveUserAdminNullConstraint < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :admin, :boolean, null: true, default: false
  end

  def down
    change_column :users, :admin, :boolean, null: false, default: false
  end
end
