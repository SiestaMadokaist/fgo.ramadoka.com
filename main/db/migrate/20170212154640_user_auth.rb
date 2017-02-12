class UserAuth < ActiveRecord::Migration
  def change
    create_table(:user_auths) do |t|
      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
      t.integer(:origin, null: false)
      t.string(:origin_id, null: false)
      t.integer(:user_id)
      t.boolean(:validated, null: false, default: false)
      t.string(:validation_token)
      t.datetime(:validation_expiry)
    end
    add_index(:user_auths, [:origin, :origin_id], unique: true)
  end
end
