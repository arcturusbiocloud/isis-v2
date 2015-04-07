class HomeController < ApplicationController

  def index
    @projects = Project.featured.page params[:page]
  end
end
