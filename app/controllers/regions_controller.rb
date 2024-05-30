class RegionsController < ApplicationController
  skip_after_action :verify_pundit_authorization, only: :index

  def index
    @regions = Region.all
    @markers = []
    @polygons = []

    @regions.each do |region|
      if region.borders.present?
        case region.borders.geometry_type
        # when RGeo::Feature::Point
        #   @markers << {
        #     lat: region.borders.y,
        #     lng: region.borders.x,
        #     info_window_html: render_to_string(partial: "info_window", locals: { region: region }),
        #     marker_html: render_to_string(partial: "marker")
        #   }
        when RGeo::Feature::Polygon
          coordinates = region.borders.exterior_ring.points.map { |point| [point.x, point.y] }
          @polygons << {
            id: region.id,
            coordinates: [coordinates]
          }
        when RGeo::Feature::MultiPolygon
          multipolygon_coordinates = region.borders.map do |polygon|
            polygon.exterior_ring.points.map { |point| [point.x, point.y] }
          end
          @polygons << {
            id: region.id,
            coordinates: multipolygon_coordinates
          }
        else
          # Handle other types or log an error
          p "Unhandled geometry type: #{region.borders.geometry_type}"
        end
      end

      @markers = @markers.compact
      @polygons = @polygons.compact
    end
  end
end
