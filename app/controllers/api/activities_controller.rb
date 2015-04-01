module API
  class ActivitiesController < API::ApplicationController
    def create
      @project = Project.find(params[:project_id])
      @activity = @project.activities.new(activity_params)

      upload_picture if @activity.picture_taken?

      @activity.save

      respond_to do |format|
        format.json { render :json => @activity }
      end
    end

    private

    def activity_params
      params[:key] = params[:key].to_i if params[:key]
      params.permit(:key, :detail)
    end

    def upload_picture
      res = Cloudinary::Uploader.upload(params["content"],
                                        public_id: public_id, tags: tags,
                                        eager: [
                                          { transformation: 'thumbnail' },
                                          { transformation: 'original' },
                                          { transformation: 'twitter-card' }
                                        ])

      # Store the secure url
      @activity.detail = res["secure_url"].gsub("upload/","upload/t_thumbnail/")

      # Update project icon with the latest image
      @project.update_attribute(:icon_url_path, @activity.detail)
    end

    def public_id
      Digest::MD5.hexdigest("#{@project.id}-#{@project.activities.count}")
    end

    def tags
      ["user_id:#{@project.user.id}", "project_id:#{@project.id}"]
    end
  end
end
