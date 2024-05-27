class CreateZoneProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :zone_projects do |t|
      t.references :country, null: true, foreign_key: true
      t.references :region, null: true, foreign_key: true
      t.references :commune, null: true, foreign_key: true
      t.references :district, null: true, foreign_key: true
      t.references :project, null: true, foreign_key: true
      t.float :latitude
      t.float :longitude
      t.geometry :geometry

      t.timestamps
    end
  end
end
