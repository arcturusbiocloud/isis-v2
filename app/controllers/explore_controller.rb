class ExploreController < ApplicationController

  # GET /explore
  def index
    @projects = Project.open_source.page params[:page]
  end
end
