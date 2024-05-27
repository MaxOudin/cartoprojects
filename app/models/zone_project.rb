class ZoneProject < ApplicationRecord
  belongs_to :country, optional: true
  belongs_to :region, optional: true
  belongs_to :commune, optional: true
  belongs_to :district, optional: true
  belongs_to :project, optional: true

  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
end
