class AddDuesFlagToSubscriptions < ActiveRecord::Migration
  def change
    add_column(:stripe_subscriptions, :dues, :boolean, default: false, null: false)
  end
end
