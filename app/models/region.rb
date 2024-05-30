class Region < ApplicationRecord
  has_many :zone_projects
  belongs_to :country, optional: true
end
