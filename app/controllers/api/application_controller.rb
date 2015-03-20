class API::ApplicationController < ActionController::Base
  respond_to :json

  before_filter :validate_access_token

  private

  def validate_access_token
    if params[:access_token] != Rails.application.secrets.access_token
      render json: { message: 'Not Authorized' }, status: 401
    end
  end
end
