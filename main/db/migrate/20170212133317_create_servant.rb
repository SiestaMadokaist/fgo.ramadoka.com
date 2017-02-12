class CreateServant < ActiveRecord::Migration
  def change
    create_table(:servants) do |t|
      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
      t.string(:name, null: false)
    end
    add_index(:servants, [:name], unique: true)
  end
end
