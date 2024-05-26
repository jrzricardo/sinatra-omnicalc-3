require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "
end

get("/umbrella") do
  "howdy"

  erb(:umbrella_form)
end

get("/process_umbrella") do
  gmaps_key = ENV.fetch("GMAPS_KEY")
  @user_location = params.fetch("user_loc")

  gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=Merchandise%20Mart%20Chicago&key=" + gmaps_key

  @raw_response = HTTP.get(gmaps_url).to_s
 
  @parsed_response = JSON.parse(@raw_response)
  
  @location_hash = @parsed_response.dig("results", 0, "geometry", "location")

  @latitude = @location_hash.fetch("lat")
  @longitude = @location_hash.fetch("lng")

  erb(:umbrella_results)
end
