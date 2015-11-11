class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index, :download]
  before_action :load_user, only: [:show, :index]
  before_action :set_project, only: [:edit, :update, :destroy, :download]
  before_action :set_tab, only: [:show]

  def index
    @projects = load_projects
  end

  def show
    @project = Project.friendly.find(params[:id])

    if accessible?
      @activities = @project.activities.order('updated_at desc')
    else
      # Not accessible, but not found is answered
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
      redirect_to username_project_path(current_user.username, @project)
    else
      render :new
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      msg = 'Ops! Something went wrong: ' + @project.errors[:base].first
      flash[:error] = msg
      redirect_to @project
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url
  end

  def download
    if params[:asset] == 'report'
      send_data @project.report_content, filename: @project.report_filename
    else
      send_data @project.gen_bank_content, filename: @project.gen_bank_filename
    end
  end

  private

  def set_project
    id = params[:id] || params[:project_id]

    @project = Project.friendly.find(id)

    return not_found unless accessible?
  end

  def load_user
    return unless params[:username]

    @user = User.find_by_username(params[:username])
    not_found unless @user
  end

  def load_projects
    return user_projects if @user

    # URL of the projects root (/projects)
    Project.open_source.page params[:page]
  end

  def user_projects
    @user.projects.page params[:page] if admin? || @user == current_user

    # URL of an user other than current_user
    @user.projects.open_source.page params[:page]
  end

  def set_tab
    return unless params['tab'].present?

    # A specific tab should be displayed, but we don't want the query string
    # visible on the URL, because it shouldn't be present on Twitter.
    # This value set on session will be handled on projects_helper.
    session[:tab] = params['tab']
    params.delete 'tab'

    redirect_to request.path
  end

  def project_params
    # Default parameters, always accessible
    list = default_parameters

    # Owner parameters, accessible only to the project owner
    list << owner_parameters if @project && owner?

    # Admin parameters, accessible only to admins
    list << admin_parameters if admin?

    params.require(:project).permit(list)
  end

  def default_parameters
    [:name, :is_open_source, :gen_bank, :gen_bank_cache, experiment_ids: []]
  end

  def owner_parameters
    params[:project] = {} if params[:project].nil?

    if params[:project].empty?
      # Append the status parameter and the stripeToken
      params[:project][:status] = 'synthesizing'
      params[:project][:stripeToken] = params[:stripeToken]
    end

    [:status, :stripeToken]
  end

  def admin_parameters
    [:price, :estimated_delivery_days, :status, :report]
  end

  def owner?
    @project.user == current_user
  end

  # Since a project can be public or private, it's necessary to be sure that
  # the project is accessible to the current user
  def accessible?
    admin? || owner? || @project.is_open_source?
  end
end
