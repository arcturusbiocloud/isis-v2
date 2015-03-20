class ExploreController < ApplicationController

  # GET /explore
  def index
    @projects = Project.is_public
  end
end
