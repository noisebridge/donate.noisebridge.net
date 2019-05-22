class AddTagToCharges < ActiveRecord::Migration[4.2]
  def change
    add_column(:charges, :tag, :string)
  end
end
