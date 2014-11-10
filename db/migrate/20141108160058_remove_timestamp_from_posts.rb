class RemoveTimestampFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :timestamp, :timestamp
  end
end
