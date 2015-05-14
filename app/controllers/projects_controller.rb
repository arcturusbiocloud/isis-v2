class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_user, only: [:show, :index]
  before_action :set_project, only: [:edit, :update, :destroy]
  before_action :set_tab, only: [:show]

  def index
    @projects = if @user
      @user.projects.open_source.page params[:page]
    else
      current_user.projects.page params[:page]
    end
  end

  def show
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
    
    if current_user.tester? && @project.save
      # Add the first activity of the timeline
      @project.activities.create!
      redirect_to username_project_path(current_user.username, @project)
    elsif current_user.active? && @project.save
      # Stripe charge
      # Amount in cents
      @amount = 8000
      # create customer
      customer = Stripe::Customer.create(
        :email => current_user.email,
        :card => params[:stripeToken]
      )
      # create charge
      charge = Stripe::Charge.create(
        :customer => customer.id,
        :amount => @amount,
        :description => '1 biological construct with 1 gene',
        :currency => 'usd'
      )

      # Add the first activity of the timeline
      @project.activities.create!
      redirect_to username_project_path(current_user.username, @project)
    else
      render :new
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    render :new
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
    @project = current_user.projects.friendly.find(params[:id])
  end

  def load_user
    if params[:username]
      @user = User.find_by_username(params[:username])
      not_found unless @user
    end
  end

  def set_tab
    if params['tab'].present?
      # A specific tab should be displayed, but we don't want the query string
      # visible on the URL, because it shouldn't be present on Twitter.
      # This value set on session will be handled on projects_helper.
      session[:tab] = params['tab']
      params.delete 'tab'

      redirect_to request.path
    end
  end

  def project_params
    params.require(:project).permit(:name, :description, :is_open_source, :design, :anchor, :promoter, :rbs, :gene, :terminator, :cap)
  end

  # Since a project can be public or private, it's necessary to be sure that
  # the project is is_accessible to the current user
  def is_accessible?
    return true if @project.is_open_source?
    @project.user == current_user
  end
end
