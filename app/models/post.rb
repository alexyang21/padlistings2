class Post < ActiveRecord::Base
  has_many :images
  
  scope :min_price, -> (min) { where("price > ?", min) }
  scope :max_price, -> (max) { where("price < ?", max) }
  scope :bedrooms, -> (bedrooms) { where bedrooms: bedrooms}
  scope :bathrooms, -> (bathrooms) { where bathrooms: bathrooms}
  scope :cats, -> (cats) { where cats: cats}
  scope :dogs, -> (dogs) { where dogs: dogs}
  scope :min_sqft, -> (min) { where("sqft > ?", min) }
  scope :max_sqft, -> (max) { where("sqft < ?", max) }
  scope :w_d_in_unit, -> (w_d_in_unit) { where w_d_in_unit: w_d_in_unit}
  scope :street_parking, -> (street_parking) { where street_parking: street_parking}
end
