class CreateDonors < ActiveRecord::Migration[4.2]
  def change
    create_table :donors do |t|
      t.string :email, null: false
      t.string :stripe_customer_id, null: false
      t.timestamps
    end
  end
end
