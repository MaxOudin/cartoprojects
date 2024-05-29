class ZoneProjectsController < ApplicationController
  skip_after_action :verify_pundit_authorization, only: :index

  def index
    @zone_projects = ZoneProject.all
    @markers = []
    @polygons = []

    @zone_projects.each do |zone_project|
      case zone_project.geometry.geometry_type
      when RGeo::Feature::Point
        @markers << {
          lat: zone_project.geometry.y,
          lng: zone_project.geometry.x,
          info_window_html: render_to_string(partial: "info_window", locals: { zone_project: zone_project }),
          marker_html: render_to_string(partial: "marker")
        }
      when RGeo::Feature::Polygon
        coordinates = zone_project.geometry.exterior_ring.points.map { |point| [point.x, point.y] }
        @polygons << {
          id: zone_project.id,
          coordinates: [coordinates]
        }
      when RGeo::Feature::MultiPolygon
        multipolygon_coordinates = zone_project.geometry.map do |polygon|
          polygon.exterior_ring.points.map { |point| [point.x, point.y] }
        end
        @polygons << {
          id: zone_project.id,
          coordinates: multipolygon_coordinates
        }
      else
        # Handle other types or log an error
        p "Unhandled geometry type: #{zone_project.geometry.geometry_type}"
      end
    end

    @markers = @markers.compact
    @polygons = @polygons.compact
  end
end
