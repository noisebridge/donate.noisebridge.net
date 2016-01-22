class AddTagToCharges < ActiveRecord::Migration
  def change
    add_column(:charges, :tag, :string)
  end
end
