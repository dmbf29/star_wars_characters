namespace :character do
  desc "Scrapes starwars.fandom.com for character photos"
  task fetch_photos: :environment do
    character_exceptions = ['Ayla Secura', 'Wicket Systri Warrick', 'Beru Whitesun lars']
    Character.find_each do |character|
      next if character.photo.present?

      if character_exceptions.include?(character.name)
        handle_character_exception_for(character)
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

  def handle_character_exception_for(character)
    characters = {
     'Ayla Secura' => 'https://starwars.fandom.com/wiki/Aayla_Secura',
     'Wicket Systri Warrick' => 'https://starwars.fandom.com/wiki/Wicket_Wystri_Warrick',
     'Beru Whitesun lars' => 'https://starwars.fandom.com/wiki/Beru_Whitesun_Lars'
    }
    puts "Handling exception for #{character.name}"
    url = characters[character.name]
    html_doc = Nokogiri.HTML(open(url).read)
    photo_div = html_doc.search('#mw-content-text .pi-background').first
    photo_img_tag = photo_div.search('img').first
    character.remote_photo_url = photo_img_tag.attributes['src'].value
    character.save
  end
end
