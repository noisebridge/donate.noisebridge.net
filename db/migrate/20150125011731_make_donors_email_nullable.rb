class MakeDonorsEmailNullable < ActiveRecord::Migration[4.2]
  def up
    change_column(:donors, :email, :string, null: true)
  end

  def down
    change_column(:donors, :email, :string, null: false)
  end
end
