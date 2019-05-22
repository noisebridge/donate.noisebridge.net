class CreateStripePlans < ActiveRecord::Migration[4.2]
  def change
    create_table :stripe_plans do |t|
      t.string :stripe_id
      t.string :name, null: false
      t.integer :amount, null: false
      t.timestamps
    end

    add_index(:stripe_plans, :stripe_id, unique: true)
  end
end
