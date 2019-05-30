class AddAnonymousToDonors < ActiveRecord::Migration[4.2]
  def up
    add_column(:donors, :anonymous, :boolean, default: false)
  end

  def down
    remove_column(:donors, :anonymous)
  end
end
