class Planet < ApplicationRecord
  has_many :characters
  mount_uploader :photo, PhotoUploader
end
