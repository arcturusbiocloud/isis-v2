module ProjectsHelper
  def is_selected?(tab, is_first=false)
    'active' if params[:tab] == tab || params[:tab].nil? && is_first
  end

  def is_project_owner?(project)
    project.user == current_user
  end

  def index_title(user)
    if user && user != current_user
      "#{user.username}'s projects"
    else
      "Your projects"
    end
  end

  def icon_class(project)
    last_activity = project.activities.last

    if last_activity && Activity.keys[last_activity.key] >= 5
      'project-thumbnail'
    else
      'project-icon'
    end
  end
end
