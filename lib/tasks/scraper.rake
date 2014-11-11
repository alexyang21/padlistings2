namespace :scraper do
  desc "Fetch craigslist posts from 3taps"
  task scrape: :environment do
    require 'open-uri'

    # Set API token and URL
    auth_token = "4df4bbf8a2d0cfffc69fb3486f11b6a0"
    polling_url = "http://polling.3taps.com/poll"
    
    loop do
    
      # Specify parameters
      params = {
        auth_token: auth_token,
        anchor: Anchor.first.value, # Remember to change anchor value
        source: "CRAIG",
        category_group: "RRRR",
        category: "RHFR",
        'location.city' => "USA-NYM-BRL",
        retvals: "id,location,timestamp,external_url,heading,body,price,annotations,images"
      }

      # Prepare API request
      uri = URI.parse(polling_url)
      uri.query = URI.encode_www_form(params)

      # Submit request
      result = JSON.parse(open(uri).read)

      # Display results to screen
      # puts JSON.pretty_generate result
      
      # Store results in database
      result["postings"].each do |line|
        
        # Create new Post
        @post = Post.new
        @post.heading = line["heading"]
        @post.body = line["body"]
        @post.external_url = line["external_url"]
        @post.external_id = line["external_id"]
        @post.timestamp = line["timestamp"]
        @post.price = line["price"]
        
        # Set annotation fields if listed
        unless line["annotations"]["bedrooms"].blank?
          @post.bedrooms = line["annotations"]["bedrooms"]
        end
        
        unless line["annotations"]["bathrooms"].blank?
          @post.bathrooms = line["annotations"]["bathrooms"]
        end
        
        unless line["annotations"]["cats"].blank?
          @post.cats = line["annotations"]["cats"]
        end
        
        unless line["annotations"]["dogs"].blank?
          @post.dogs = line["annotations"]["dogs"]
        end
        
        unless line["annotations"]["sqft"].blank?
          @post.sqft = line["annotations"]["sqft"]
        end
        
        unless line["annotations"]["w_d_in_unit"].blank?
          @post.w_d_in_unit = line["annotations"]["w_d_in_unit"]
        end
        
        unless line["annotations"]["street_parking"].blank?
          @post.street_parking = line["annotations"]["street_parking"]
        end
        
        if line["location"]["locality"].blank?
          @post.neighborhood = ""
        else
          @post.neighborhood = Location.find_by(code: line["location"]["locality"]).name
        end
        
        # Save Post
        @post.save
        
        
        # Create new Images
        line["images"].each do |image|
          @image = Image.new
          @image.image_type = "full"
          @image.url = image["full"]
          @image.post_id = @post.id
          @image.save
        end
    
      end
      puts result["anchor"]
      Anchor.first.update(value: result["anchor"])
      
      break if result["postings"].empty?
    end
  end
  
  desc "Delete database"
  task clear: :environment do
    Post.all.each do |post|
      if post.timestamp.to_i < 3.hours.ago.to_i
        post.destroy
      end
    end
  end
  
  desc "Store location information in reference database"
  task set_locations: :environment do
    require 'open-uri'

    # Set API token and URL
    auth_token = "4df4bbf8a2d0cfffc69fb3486f11b6a0"
    reference_url = "http://reference.3taps.com/locations"
    
    params = {
      auth_token: auth_token,
      city: "USA-NYM-BRL",
      level: "locality"
    }
    
    # Prepare API request
    uri = URI.parse(reference_url)
    uri.query = URI.encode_www_form(params)
    
    # Submit request
    result = JSON.parse(open(uri).read)
    
    # Display results to screen
    # puts JSON.pretty_generate result["locations"]
    
    result["locations"].each do |location|
      @location = Location.new
      @location.code = location["code"]
      @location.name = location["short_name"]
      @location.save
    end
  end
end