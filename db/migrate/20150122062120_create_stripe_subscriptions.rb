class CreateStripeSubscriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :stripe_subscriptions do |t|
      t.integer :stripe_plan_id, null: false
      t.string :stripe_customer_id
      t.string :stripe_status
      t.datetime :cancellation_requested_at
      t.datetime :cancelled_at
      t.timestamps
    end
  end
end
