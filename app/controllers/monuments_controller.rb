class MonumentsController < ApplicationController
  skip_after_action :verify_pundit_authorization, only: :index

  def index
    @monuments = Monument.all

    # The `geocoded` scope filters only monuments with coordinates
    @markers = @monuments.geocoded.map do |monument|
      {
        lat: monument.latitude,
        lng: monument.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {monument: monument}),
        marker_html: render_to_string(partial: "marker", locals: {monument: monument})
      }
    end
  end
end
