module ProjectsHelper
  def is_selected?(tab, is_first=false)
    'active' if params[:tab] == tab || params[:tab].nil? && is_first
  end

  def is_project_owner?(project)
    project.user == current_user
  end

  def icon_class(project)
    last_activity = project.activities.last

    if last_activity && Activity.keys[last_activity.key] >= 5
      'project-thumbnail'
    else
      'project-icon'
    end
  end

  def activity_icon(activity)
    case activity.key
      when "created" then "clock-o"
      when "assembling" then "random"
      when "transforming" then "flask"
      when "plating" then "eyedropper"
      when "incubating" then "sun-o"
      when "picture_taken" then "picture-o"
      when "completed" then "check-square-o"
    end
  end

  def activity_background(activity)
    case activity.key
      when "created" then "cd-picture"
      when "assembling" then "cd-running"
      when "transforming" then "cd-movie"
      when "plating" then "cd-plating"
      when "incubating" then "cd-location"
      when "picture_taken" then "cd-movie"
      when "completed" then "cd-picture"
    end
  end

  def activity_title(activity)
    case activity.key
      when "created" then "Project created!"
      when "assembling" then "Assembling"
      when "transforming" then "Transforming"
      when "plating" then "Plating"
      when "incubating" then "Incubating"
      when "picture_taken" then "Picture taken!"
      when "completed" then "Project finished!"
    end
  end

  def activity_description(activity)
    case activity.key
      when "created" then "<p>Arc just created your project and is going to run it as soon as possible.</p>"
      when "assembling" then "<p>Arc just got all the genetic parts and configurations to assemble your genetic circuit. You can watch the video of the process and learn more about it!</p><p><div id='player'>Loading video...</div></p>"
      when "transforming" then "<p>Arc is transforming a competent cell with your genetic circuit.</p>"
      when "plating" then "<p>Arc is plating your transformed competent cell in a petri dish with agar.</p>"
      when "running" then "<p>Arc just got all the consumables and configurations to start your experiment and now is working for you. This step is going to take approximately 10 minutes to be completed.</p>"
      when "incubating" then "<p>Arc is incubating your experiment for the next 36 hours.</p>"
      when "picture_taken" then "<p>Arc just got a picture of your experiment: <br/><br/><a href=\"#{activity.detail.gsub('t_thumbnail','t_original')}\" class=\"fancybox\" rel=\"gallery1\">#{image_tag activity.detail, class: 'img-thumbnail'}<p class=\"lighterbox-title\"></a></p>"
      when "completed" then "<p>Arc just finished your experiment. You can check the insights and pictures to see if your genetic circuit is working as expected.</p>"
    end
  end
end
