class SetDonorEmailNotNull < ActiveRecord::Migration
  def up
    change_column(:donors, :email, :string, null: false)
  end

  def down
    change_column(:donors, :email, :string, null: true)
  end
end
