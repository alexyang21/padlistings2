class AddNeighborhoodToPost < ActiveRecord::Migration
  def change
    add_column :posts, :neighborhood, :string
  end
end
