class CharacterPlanet < ApplicationRecord
  belongs_to :character
  belongs_to :planet
end
