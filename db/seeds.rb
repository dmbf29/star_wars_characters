# response = HTTParty.get('https://swapi.co/api/planets/?format=json')
# (1..61).to_a.each do |id|
(1..1).to_a.each do |id|
  response = HTTParty.get("https://swapi.co/api/planets/#{id}/?format=json")
  planet_hash = response.parsed_response
  p planet_hash
end
