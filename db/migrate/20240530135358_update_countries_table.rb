class UpdateCountriesTable < ActiveRecord::Migration[7.1]
  def change
    change_table :countries do |t|
      # Adding new columns
      t.string :name
      t.string :iso_code
      t.string :code
      t.bigint :continent_id

      # Removing old columns
      t.remove :shape1
      t.remove :shape2
      t.remove :path
      t.remove :lonlat
      t.remove :lonlatheight

      # Adding new geometries
      t.geometry :borders, limit: { srid: 0, type: "geometry" }
      t.geography :hi_point, limit: { srid: 4326, type: "st_point", has_z: true, geographic: true }
      t.geography :low_point, limit: { srid: 4326, type: "st_point", has_z: true, geographic: true }

      # Adding indexes
      t.index :continent_id
    end
  end
end
