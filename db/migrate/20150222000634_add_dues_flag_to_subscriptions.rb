class AddDuesFlagToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column(:stripe_subscriptions, :dues, :boolean, default: false, null: false)
  end
end
