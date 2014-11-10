class AddTimestampToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :timestamp, :string
  end
end
