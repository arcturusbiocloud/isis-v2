class PeopleController < ApplicationController
  def index
    @people = User.all.page params[:page]
  end
end
