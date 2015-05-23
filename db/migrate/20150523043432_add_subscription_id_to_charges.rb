class AddSubscriptionIdToCharges < ActiveRecord::Migration
  def up
    add_column(:charges, :subscription_id, :integer)
  end

  def down
    remove_column(:charges, :subscription_id)
  end
end
