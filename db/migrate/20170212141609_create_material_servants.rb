class CreateMaterialServants < ActiveRecord::Migration
  def change
    create_table(:material_servants) do |t|
      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
      t.integer(:material_id, null: false)
      t.integer(:servant_id, null: false)
      t.integer(:classifier, null: false)
      t.integer(:count, null: false)
      t.integer(:level, null: false)
    end
    add_index(:material_servants, [:material_id, :servant_id, :classifier, :level], unique: true, name: :fk1)
  end
end
