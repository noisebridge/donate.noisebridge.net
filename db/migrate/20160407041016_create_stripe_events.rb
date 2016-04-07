class CreateStripeEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_events do |t|
      t.string :stripe_id, null: false
      t.json :body
      t.datetime :processed_at
      t.timestamps
    end
  end
end
