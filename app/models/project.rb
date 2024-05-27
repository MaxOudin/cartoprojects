class Project < ApplicationRecord
  belongs_to :user
  has_many :zone_projects, dependent: :destroy
  has_one_attached :file

  validates :name, presence: true, uniqueness: true
  # validates :description, presence: true

end
