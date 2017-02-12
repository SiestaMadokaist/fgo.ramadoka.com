class AddNToMaterialServant < ActiveRecord::Migration
  def change
    add_column(:material_servants, :n, :integer, null: false)
  end
end
