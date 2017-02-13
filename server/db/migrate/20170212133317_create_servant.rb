class CreateServant < ActiveRecord::Migration
  def change
    create_table(:servants) do |t|
      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
      t.integer(:klass, null: false)
      t.integer(:star, null: false)
      t.string(:name, null: false)
      t.string(:slug, null: false)
    end
    add_index(:servants, [:slug], unique: true)
  end
end
