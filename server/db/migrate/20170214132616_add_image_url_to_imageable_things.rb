class AddImageUrlToImageableThings < ActiveRecord::Migration
  def change
    add_column(:servants, :thumbnail_url, :string, null: false)
    add_column(:users, :thumbnail_url, :string, null: false)
    add_column(:materials, :thumbnail_url, :string, null: false)
  end
end
