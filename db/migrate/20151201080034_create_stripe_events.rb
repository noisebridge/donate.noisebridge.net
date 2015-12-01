class CreateStripeEvents < ActiveRecord::Migration
  def change
    create_table :stripe_events do |t|
      t.string :stripe_id, null: false
      t.string :type, null: false
      t.string :request
      t.json :data
      t.datetime :processed_at
      t.datetime :remote_created_at
      t.timestamps
    end

    add_index(:stripe_events, :stripe_id, unique: true)
  end
end
