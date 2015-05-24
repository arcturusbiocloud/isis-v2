class PeopleController < ApplicationController

  # GET /people
  def index
    @people = User.all.page params[:page]
  end
end
