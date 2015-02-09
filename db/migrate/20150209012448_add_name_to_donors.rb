class AddNameToDonors < ActiveRecord::Migration
  def up
    add_column(:donors, :name, :string, limit: 120)
  end

  def down
    remove_column(:donors, :name)
  end
end
