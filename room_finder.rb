require 'net/http'
require 'json'
require 'optparse'

options = {}
OptionParser.new do |parser|
  parser.on("-s", "--source=SOURCE", 'Source Address or lat/long') {|source| options[:source] = source }
  parser.on("-d", "--destination=DESTINATIONS", '| seperated destination addresses or lat/long') do |destination| 
    options[:destinations] = destination.split("|")
  end
  parser.on("-k", "--key=GOOGLE_API_KEY", "Google API Key") {|key| options[:key] = key }
end.parse!

raise Exception if options.keys.size != 3
p options
key = options[:key]
source = options[:source]
destinations = options[:destinations]

result = []
all_results = []
destinations.each do |destination|
  encoded_url = URI::encode("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=#{source}&destinations=#{destination}&key=#{key}")
  uri = URI(encoded_url)
  response = Net::HTTP.get(uri)
  parsed_json = JSON.parse(response)
  distance = parsed_json["rows"][0]["elements"][0]["distance"]["value"]
  ghash = {"place" => destination, "distance" => distance}
  all_results << ghash
  result << ghash if(distance < 3000)
end

p "ALL RESULTS"
p all_results

p "FAVORABLE RESULTS"
p result