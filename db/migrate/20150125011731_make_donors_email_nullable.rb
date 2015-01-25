class MakeDonorsEmailNullable < ActiveRecord::Migration
  def up
    change_column(:donors, :email, :string, null: true)
  end

  def down
    change_column(:donors, :email, :string, null: false)
  end
end
