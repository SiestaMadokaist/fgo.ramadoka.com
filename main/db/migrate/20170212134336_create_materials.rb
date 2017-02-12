class CreateMaterials < ActiveRecord::Migration
  def change
    create_table(:materials) do |t|
      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
      t.string(:name, null: false)
      t.string(:slug, null: false)
    end
    add_index(:materials, :slug, unique: true)
  end
end
