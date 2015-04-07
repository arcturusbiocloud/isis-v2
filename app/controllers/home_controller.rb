class HomeController < ApplicationController

  def index
    @projects = Project.featured
  end
end
