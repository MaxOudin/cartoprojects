class ZoneProjectsController < ApplicationController
  skip_after_action :verify_pundit_authorization, only: :index

  def index
    @zone_projects = ZoneProject.all
    @markers = @zone_projects.map do |zone_project|
      {
        lat: zone_project.geometry.y,
        lng: zone_project.geometry.x,
        info_window_html: render_to_string(partial: "info_window", locals: { zone_project: zone_project }),
        marker_html: render_to_string(partial: "marker")
      }
    end
  end
end
