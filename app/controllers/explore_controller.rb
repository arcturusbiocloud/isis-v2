class ExploreController < ApplicationController
  def index
    @projects = Project.open_source.page params[:page]
  end
end
