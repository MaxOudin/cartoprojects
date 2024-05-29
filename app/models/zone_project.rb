class ZoneProject < ApplicationRecord
  belongs_to :country, optional: true
  belongs_to :region, optional: true
  belongs_to :commune, optional: true
  belongs_to :district, optional: true
  belongs_to :project, optional: true

  validates :geometry, presence: true
end
