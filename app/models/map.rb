class Map < ApplicationRecord
  after_validation :geocode
end
