class Project < ApplicationRecord
  belongs_to :user
  has_many :zone_projects, dependent: :destroy
  has_many :communes, through: :zone_projects
  has_many :countries, through: :zone_projects
  has_many :regions, through: :zone_projects
  has_many :districts, through: :zone_projects
  has_one_attached :file

  validates :name, presence: true, uniqueness: true
  # validates :description, presence: true

end
