# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create User
user = User.create!(email: 'user@example.com', password: 'password', first_name: 'First', last_name: 'Last')
p "#{user.email} user created"

# Create Project
project = Project.create!(name: 'Project in Yaoundé', description: 'A description of the project in Yaounde', user: user)
p "#{project.name} created"

# Create Country, Region, Commune, District
country = Country.create!(latitude: 3.8480, longitude: 11.5021)
region = Region.create!(latitude: 3.8480, longitude: 11.5021)
commune = Commune.create!(latitude: 3.8480, longitude: 11.5021)
district = District.create!(latitude: 3.8480, longitude: 11.5021)

# Create ProjectLocation
zone_project = ZoneProject.create!(
  country: country,
  region: region,
  commune: commune,
  district: district,
  project: project,
  geometry: 'POINT(11.5021 3.8480)'
)
p "#{zone_project.project.name} location created"
