class CreateCharges < ActiveRecord::Migration[4.2]
  def change
    create_table :charges do |t|
      t.integer :donor_id, null: false
      t.integer :amount, null: false
      t.string  :stripe_charge_id, null: false
      t.timestamps
    end
  end
end
