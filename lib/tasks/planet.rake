namespace :planet do
  desc "Scrapes starwars.fandom.com for photos"
  task fetch_photos: :environment do
    planet_exceptions = ['Ojom', 'Zolan', 'Tholoth', 'Aleen Minor', 'Stewjon']
    Planet.find_each do |planet|
      next if planet.photo.present?

      if planet_exceptions.include?(planet.name)
        handle_exception_for(planet)
      else
        url =  URI.encode("https://starwars.fandom.com/wiki/#{planet.name.gsub("\"", "'").gsub(" ", "_")}")
        begin
          html_doc = Nokogiri.HTML(open(url).read)
          if html_doc
            photo_div = html_doc.search('#mw-content-text .pi-background').first
            if photo_div
              photo_img_tag = photo_div.search('img').first
              if photo_img_tag
                photo_url = photo_img_tag.attributes['src'].value
                if photo_url
                  planet.remote_photo_url = photo_url
                  planet.save
                end
                puts "Photo added for #{planet.name}"
              else
                puts "Photo img tag not found for #{planet.name}"
              end
            else
              puts "Photo not found for #{planet.name}"
            end
          else
            puts "HTML not found for #{planet.name}"
          end
        rescue OpenURI::HTTPError => ex
          puts "#{planet.name} has a 404 page"
        end
      end
    end
  end

  def handle_exception_for(planet)
    planets = {
      'Ojom' => 'https://vignette.wikia.nocookie.net/starwars/images/9/9f/Ojom.jpg/revision/latest?cb=20061119201000',
      'Zolan' => 'https://vignette.wikia.nocookie.net/starwars/images/6/66/Zolan.jpg/revision/latest?cb=20070701111500',
      'Tholoth' => 'https://vignette.wikia.nocookie.net/starwars/images/1/1d/CaridaSpace.jpg/revision/latest?cb=20070706034859',
      'Aleen Minor' => 'https://vignette.wikia.nocookie.net/starwars/images/f/f6/Aleen_NEGAS.jpg/revision/latest?cb=20070630172856',
      'Stewjon' => 'https://holopedia.de/thumb.php?f=PlanetStewjon.jpg&width=900',
      'unknown' => 'https://i.dailymail.co.uk/i/pix/2016/05/04/18/33D6348E00000578-3573624-The_glittering_city_lights_of_Coruscant_the_Star_Wars_core_world-a-53_1462382123507.jpg'
    }
    puts "Handling exception for #{planet.name}"
    planet.remote_photo_url = planets[planet.name]
    planet.save
  end
end
