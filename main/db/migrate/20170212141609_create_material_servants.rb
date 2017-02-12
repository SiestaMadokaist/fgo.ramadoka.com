class CreateMaterialServants < ActiveRecord::Migration
  def change
    create_table(:material_servants) do |t|
      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
      t.integer(:material_id, null: false)
      t.integer(:servant_id, null: false)
      t.integer(:classifier, null: false)
      t.integer(:count, null: false)
    end
  end
end
