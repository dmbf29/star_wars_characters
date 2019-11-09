# response = HTTParty.get('https://swapi.co/api/planets/?format=json')
# (1..61).to_a.each do |id|
unless Planet.count == 61
  puts "Creating planets..."
  (1..61).to_a.each do |id|
    response = HTTParty.get("https://swapi.co/api/planets/#{id}/?format=json")
    planet = response.parsed_response
    puts planet['name'] + '...'
    Planet.where(
      name: planet['name'],
      rotation_period: planet['rotation_period'].to_i,
      orbital_period: planet['orbital_period'].to_i,
      diameter: planet['diameter'].to_i,
      climate: planet['climate'],
      gravity: planet['gravity'],
      terrain: planet['terrain'],
      surface_water: planet['surface_water'],
      population: planet['population'].to_i,
      url: planet['url']
    ).first_or_create!
  end
  puts "...finished planets. Total: #{Planet.count}"
end

unless Character.count == 87
  puts "Creating characters..."
  (1..87).to_a.each do |id|
    response = HTTParty.get("https://swapi.co/api/people/#{id}/?format=json")
    character = response.parsed_response
    next unless character['name']

    puts character['name'] + '...'
    Character.where(
      name: character['name'],
      height: character['height'].to_i,
      mass: character['mass'].to_i,
      hair_color: character['hair_color'],
      skin_color: character['skin_color'],
      eye_color: character['eye_color'],
      birth_year: character['birth_year'],
      gender: character['gender'],
      url: character['url'],
      planet: Planet.find_by_url(character['homeworld'])
    ).first_or_create!
  end
  puts "...finished characters. Total: #{Character.count}"
end
