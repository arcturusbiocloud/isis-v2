module API
  class ProjectsController < API::ApplicationController
    def update
      @project = Project.find(params[:id])
      @project.update(activity_params)

      respond_to do |format|
        format.json { render :json => @project }
      end
    end

    private

    def activity_params
      params[:status] = params[:status].to_i if params[:status]
      params.permit(:status)
    end
  end
end
