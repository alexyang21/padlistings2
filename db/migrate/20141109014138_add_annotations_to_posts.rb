class AddAnnotationsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :bedrooms, :integer, default: nil
    add_column :posts, :bathrooms, :decimal, default: nil
    add_column :posts, :cats, :string, default: nil
    add_column :posts, :dogs, :string, default: nil
    add_column :posts, :sqft, :integer, default: nil
    add_column :posts, :w_d_in_unit, :string, default: nil
    add_column :posts, :street_parking, :string, default: nil
  end
end
