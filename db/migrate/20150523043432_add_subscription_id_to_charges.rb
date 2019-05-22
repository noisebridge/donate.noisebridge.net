class AddSubscriptionIdToCharges < ActiveRecord::Migration[4.2]
  def up
    add_column(:charges, :subscription_id, :integer)
  end

  def down
    remove_column(:charges, :subscription_id)
  end
end
