module ProjectsHelper
  def is_selected?(tab, is_first=false)
    'active' if params[:tab] == tab || params[:tab].nil? && is_first
  end

  def is_project_owner?(project)
    project.user == current_user
  end

  def activity_icon(activity)
    case activity.key
      when "created" then "clock-o"
      when "running" then "eyedropper"
      when "incubating" then "sun-o"
      when "picture_taken" then "picture-o"
      when "completed" then "check-square-o"
    end
  end

  def activity_background(activity)
    case activity.key
      when "created" then "cd-picture"
      when "running" then "cd-running"
      when "incubating" then "cd-location"
      when "picture_taken" then "cd-movie"
      when "completed" then "cd-picture"
    end
  end

  def activity_title(activity)
    case activity.key
      when "created" then "Project created!"
      when "running" then "Project running!"
      when "incubating" then "Project incubating!"
      when "picture_taken" then "Picture taken!"
      when "completed" then "Project finished!"
    end
  end

  def activity_description(activity)
    case activity.key
      when "created" then "<p>Arc just created your project and is going to run it in 2 minutes.</p>"
      when "running" then "<p>Arc just got all the consumables and configurations to start your experiment and now is working for you. This step is going to take approximately 10 minutes to be completed.</p><p>#{link_to 'Watch the transformation process!', activity.detail}</p>"
      when "incubating" then "<p>Arc just finished the transformation process and now is incubating your experiment. This step is going to take approximately 20 hours to be completed.</p>"
      when "picture_taken" then "<p>Arc just got a picture of your experiment. #{link_to 'Check it out!', activity.detail}</p>"
      when "completed" then "<p>Arc just finished the incubation of your experiment.</p>"
    end
  end
end
