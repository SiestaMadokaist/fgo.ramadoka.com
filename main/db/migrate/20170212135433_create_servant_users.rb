class CreateServantUsers < ActiveRecord::Migration
  def change
    create_table(:servant_users) do |t|
      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
      t.integer(:servant_id, null: false)
      t.integer(:user_id, null: false)
    end
    add_index(:servant_users, [:servant_id, :user_id], unique: true)
  end
end
