namespace :character do
  desc "Scrapes starwars.fandom.com for character photos"
  task fetch_photos: :environment do
    planet_exceptions = []
    Character.find_each do |character|
      next if character.photo.present?

      if character_exceptions.include?(character.name)
        handle_exception_for(character)
      else
        url =  URI.encode("https://starwars.fandom.com/wiki/#{character.name.gsub("\"", "'").gsub(" ", "_")}")
        begin
          html_doc = Nokogiri.HTML(open(url).read)
          if html_doc
            photo_div = html_doc.search('#mw-content-text .pi-background').first
            if photo_div
              photo_img_tag = photo_div.search('img').first
              if photo_img_tag
                photo_url = photo_img_tag.attributes['src'].value
                if photo_url
                  character.remote_photo_url = photo_url
                  character.save
                end
                puts "Photo added for #{character.name}"
              else
                puts "Photo img tag not found for #{character.name}"
              end
            else
              puts "Photo not found for #{character.name}"
            end
          else
            puts "HTML not found for #{character.name}"
          end
        rescue OpenURI::HTTPError => ex
          puts "#{character.name} has a 404 page"
        end
      end
    end
  end

  def handle_exception_for(character)
    characters = {}
    puts "Handling exception for #{character.name}"
    character.remote_photo_url = characters[character.name]
    character.save
  end

end
