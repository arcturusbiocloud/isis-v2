module API
  class UsersController < API::ApplicationController
    def update
      @user = User.find_by_email(params[:id])
      @user.update(user_params)

      respond_to do |format|
        format.json { render :json => @user }
      end
    end

    private

    def user_params
      params[:status] = params[:status].to_i if params[:status]
      params.permit(:status)
    end
  end
end
