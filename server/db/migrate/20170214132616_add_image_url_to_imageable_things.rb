class AddImageUrlToImageableThings < ActiveRecord::Migration
  def change
    add_column(:servants, :thumbnail_url, :string)
    add_column(:users, :thumbnail_url, :string)
    add_column(:materials, :thumbnail_url, :string)
  end
end
