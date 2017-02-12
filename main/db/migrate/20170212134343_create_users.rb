class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
      t.string(:name, null: false)
      t.string(:password, null: false)
    end
  end
end
