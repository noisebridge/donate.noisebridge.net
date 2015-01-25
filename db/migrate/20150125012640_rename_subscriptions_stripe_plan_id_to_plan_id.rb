class RenameSubscriptionsStripePlanIdToPlanId < ActiveRecord::Migration
  def up
    remove_column(:stripe_subscriptions, :stripe_plan_id)
    add_column(:stripe_subscriptions, :plan_id, :integer, null: false)
  end

  def down
    remove_column(:stripe_subscriptions, :plan_id)
    add_columnc(:stripe_subscriptions, :stripe_plan_id, :string, null: false)
  end
end
