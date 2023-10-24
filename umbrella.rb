require "http"
require "json"

#Ask the user for their location.
puts "Which city are you in?"

#Get and store the user’s location.
user_location = gets.chomp

#Get the user’s latitude and longitude from the Google Maps API.
gmaps_key = ENV.fetch("GMAPS_KEY")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

raw_gmaps_data = HTTP.get(gmaps_url)

parsed_gmaps_data = JSON.parse(raw_gmaps_data)

results_array = parsed_gmaps_data.fetch("results")

if results_array.empty?
  puts "No results found for the given location"
  return
end

first_result_hash = results_array.at(0)

unless first_result_hash.has_key?("geometry")
  puts "No geometry data found for the location"
  return
end

geometry_hash = first_result_hash.fetch("geometry")
location_hash = geometry_hash.fetch("location")

longitude_hash = location_hash.fetch("lng")
latitude_hash = location_hash.fetch("lat")

puts "Your coordinates are #{longitude_hash} and #{latitude_hash}."

#Get the weather at the user’s coordinates from the Pirate Weather API.
pirates_key = ENV.fetch("PIRATES_KEY")
pirates_url = "https://api.pirateweather.net/forecast/#{pirates_key}/#{latitude_hash},#{longitude_hash}"

raw_pirates_data = HTTP.get(pirates_url)

parsed_pirates_data = JSON.parse(raw_pirates_data)

currently_hash = parsed_pirates_data.fetch("currently")

temperature = currently_hash.fetch("temperature")

#Display the current temperature
puts "It is currently #{temperature}°F."

#Display summary of the weather for the next hour
hourly_hash = parsed_pirates_data.fetch("hourly")

hourly_summary_hash = hourly_hash.fetch("summary")

puts "Next hour's forecast: #{hourly_summary_hash}."
