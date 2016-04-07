class AddUniqueIndexToStripeEventStripeId < ActiveRecord::Migration[5.0]
  def change
    add_index(:stripe_events, :stripe_id, unique: true, using: :btree)
  end
end
