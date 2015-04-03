class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_project, only: [:edit, :update, :destroy]

  def index
    if params[:username]
      @user = User.find_by_username(params[:username])
      not_found unless @user
    end

    @projects = (@user || current_user).projects
  end

  def show
    if params[:username]
      @user = User.find_by_username(params[:username])
      not_found unless @user
    end

    @project = if @user
      @user.projects.friendly.find(params[:id])
    else
      Project.friendly.find(params[:id])
    end

    if is_accessible?
      @activities = @project.activities.order('updated_at desc')
    else
      # Not accessible, but we answer with not found, to make it harder to
      # guess that the project is private
      not_found
    end
  end

  def new
    @project = current_user.projects.new
  end

  def edit
  end

  def create
    @project = current_user.projects.new(project_params)

    if @project.save
      # Add the first activity of the timeline
      @project.activities.create!
      redirect_to @project
    else
      render :new
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :is_public, :design)
  end

  # Since a project can be public or private, it's necessary to be sure that
  # the project is is_accessible to the current user
  def is_accessible?
    return true if @project.is_public?
    @project.user == current_user
  end
end
