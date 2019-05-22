class ChangeStripeSubscriptionOwnership < ActiveRecord::Migration[4.2]
  def up
    remove_column(:stripe_subscriptions, :stripe_customer_id)
    add_column(:stripe_subscriptions, :donor_id, :integer, null: false)
  end

  def down
    remove_column(:stripe_subscriptions, :donor_id)
    remove_column(:stripe_subscriptions, :stripe_customer_id, :string, null: false)
  end
end
