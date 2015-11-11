class DashboardController < ApplicationController
  before_action :only_admins
  before_action :update_status_parameter, only: :index

  def index
    @projects = if params[:status]
                  Project.where(status: params[:status])
                else
                  Project.all
                end
  end

  private

  def update_status_parameter
    return unless params[:status]
    params[:status] = status_number[params[:status].underscore.to_sym]
  end

  def status_number
    {
      quoting: 0,
      payment_pending: 1,
      synthesizing: 2,
      getting_data: 3,
      done: 4
    }
  end
end
