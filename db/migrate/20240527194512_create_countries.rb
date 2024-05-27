class CreateCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :countries do |t|
      t.float :latitude
      t.float :longitude
      t.geometry :shape1
      t.geometry :shape2
      t.line_string :path, srid: 3785
      t.st_point :lonlat, geographic: true
      t.st_point :lonlatheight, geographic: true, has_z: true

      t.timestamps
    end
  end
end
