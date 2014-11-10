class AddFieldsToPost < ActiveRecord::Migration
  def change
    add_column :posts, :external_url, :string
    add_column :posts, :external_id, :string
    add_column :posts, :timestamp, :timestamp
    add_column :posts, :price, :decimal
  end
end
