class CreatePaypalNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :paypal_notifications do |t|
      t.string    :notification_id, null: false
      t.text      :payload,         null: false
      t.datetime  :processed_at
      t.timestamps
    end

    add_index(:paypal_notifications, :notification_id, unique: true)
  end
end
