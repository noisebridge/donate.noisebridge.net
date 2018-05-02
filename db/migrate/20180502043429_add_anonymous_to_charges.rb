class AddAnonymousToCharges < ActiveRecord::Migration[5.0]
  def change
    add_column(:charges, :anonymous, :boolean, default: true, null: false)
  end
end
