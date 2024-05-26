require "sinatra"
require "sinatra/reloader"
require "http"

gmaps_key = ENV.fetch("GMAPS_KEY")
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
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
 
  @user_location = params.fetch("user_loc")

  url_encoded_string = @user_location.gsub(" ", "+")

  gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{url_encoded_string}&key=" + gmaps_key

  @raw_response = HTTP.get(gmaps_url).to_s
 
  @parsed_response = JSON.parse(@raw_response)
  
  @location_hash = @parsed_response.dig("results", 0, "geometry", "location")

  @latitude = @location_hash.fetch("lat")
  @longitude = @location_hash.fetch("lng")

  pirate_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{@latitude},#{@longitude}"
 
  @raw_pirate_response = HTTP.get(pirate_url).to_s

  @parsed_pirate_response = JSON.parse(@raw_pirate_response)
  
  @currently_hash = @parsed_pirate_response.fetch("currently")

  @temperature = @currently_hash.fetch("temperature")

  @summary = @currently_hash.fetch("summary")

  @hour_hash = @parsed_pirate_response.fetch("hourly")

  @hour_data_array = @hour_hash.fetch("data")
  
  @next_twelve_hours = @hour_data_array[1..12]
  
  @precip_prob_threshold = 0.10

  @any_precipitation = false


  @next_tweleve_hours.each do | an_hour |
    @precip_prob = an_hour.fetch("precipProbability")

  if @precip_prob > @precip_prob_threshold
    @any_precipitation = true
  end
end

end
