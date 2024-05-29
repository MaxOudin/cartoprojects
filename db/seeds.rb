# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# user = User.create!(email: 'user@example.com', password: 'password', first_name: 'First', last_name: 'Last')
# p "#{user.email} user created"

# project = Project.create!(name: 'Project in Yaoundé', description: 'A description of the project in Yaounde', user: user)
# p "#{project.name} created"

# country = Country.create!(latitude: 3.8480, longitude: 11.5021)
# region = Region.create!(latitude: 3.8480, longitude: 11.5021)
# commune = Commune.create!(latitude: 3.8480, longitude: 11.5021)
# district = District.create!(latitude: 3.8480, longitude: 11.5021)

# zone_project = ZoneProject.create!(
#   country: country,
#   region: region,
#   commune: commune,
#   district: district,
#   project: project,
#   geometry: 'POINT(11.5021 3.8480)'
# )
# p "#{zone_project.project.name} location created"


# Madaseed

# file_r = File.open('db/seeds/madagascar/geo_data/region_mgas_ms_l10.json')
# region_data = JSON.load(file_r)

# simplified = region_data['features'].map{|r| r['properties']}.map{|p| {nom: p['ADM1_EN'], reg_code: p['ADM1_PCODE'], x:p['cent_X'], y: p['cent_Y']}}

# shapes_dict = {}
# region_data['features'].each { |r| shapes_dict[r['properties']['ADM1_PCODE']] = r['geometry'] }

# simplified.each do |region_data|
#   zone_project = ZoneProject.create(
#     nom: region_data[:nom],
#     reg_code: region_data[:reg_code],
#     x: region_data[:x],
#     y: region_data[:y]
#   )

# EntityInstance.where(entity: region_entity).each do |region|
#   reg_code = region.payload[Language.default]['reg_code']['value']
#   tmp_center = simplified.find{|r| r[:reg_code] == reg_code}
#   if tmp_center
#     geometry = {
#         "coordinates"=> [
#           tmp_center[:x],tmp_center[:y]
#         ],
#         "type"=> "Polygon"
#     }
#     geoj = RGeo::GeoJSON.decode(geometry)

#     tmp_val = RGeo::GeoJSON.encode(geoj, json_parser: :json).to_json

#     current_locales.each do |l|
#       region.payload[l]['center']['value'] = tmp_val
#     end
#     region.save
#   end

#   geoj = RGeo::GeoJSON.decode(shapes_dict[reg_code])
#   region.geo_feature = geoj
#   region.save
# end



require 'rgeo'
require 'rgeo/geo_json'
require 'json'

# Lire le fichier JSON
file_r = File.open('db/seeds/madagascar/geo_data/region_mgas_ms_l10.json')
file = file_r.read
data = JSON.parse(file)

# Créer une factory pour générer des objets RGeo
factory = RGeo::Geographic.spherical_factory(srid: 4326)

# # Extraire la géométrie du premier polygone
# # geojson_geom = data['features'][0]['geometry'] # Assumant que le polygone est dans la première feature

# # Parse la géométrie GeoJSON pour créer un objet RGeo
# geom = RGeo::GeoJSON.decode(geojson_geom.to_json, json_parser: :json, geo_factory: factory)

# # Associer l'objet RGeo au modèle ActiveRecord ZoneProject
# zone_project = ZoneProject.new
# zone_project.project = Project.find_by(name: "National Mada all Regions")
# zone_project.geometry = geom
# zone_project.save
# p "#{zone_project.project.name} location created"

# Itérer sur chaque région dans les données GeoJSON
data['features'].each do |mada_region|
  # Extraire la géométrie de la région
  geojson_geom = mada_region['geometry']

  # Parse la géométrie GeoJSON pour créer un objet RGeo
  geom = RGeo::GeoJSON.decode(geojson_geom.to_json, json_parser: :json, geo_factory: factory)

  # Associer l'objet RGeo au modèle ActiveRecord ZoneProject
  zone_project = ZoneProject.new
  zone_project.project = Project.find_by(name: "National Mada all Regions")
  zone_project.geometry = geom

  # Sauvegarder le ZoneProject
  if zone_project.save
    puts "ZoneProject saved successfully for region: #{mada_region['properties']['name']}"
  else
    puts "Failed to save ZoneProject for region: #{mada_region['properties']['name']}"
  end
end
