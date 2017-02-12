class CreateMaterials < ActiveRecord::Migration
  def change
    create_table(:materials) do |t|
      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
      t.string(:name, null: false)
    end
  end
end
