class AddStripeSubscriptionIdToStripeSubscriptions < ActiveRecord::Migration
  def up
    add_column(:stripe_subscriptions, :stripe_subscription_id, :string, null: false)
  end

  def down
    remove_column(:stripe_subscriptions, stripe_subscription_id)
  end
end
