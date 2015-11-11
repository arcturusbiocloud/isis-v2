module DashboardHelper
  def project_action(project)
    case project.status
    when 'quoting' then 'Set Price'
    when 'synthesizing' then 'Advance to Getting data'
    when 'getting_data' then 'Attach report and finish'
    else 'N/A'
    end
  end

  def actionable?(project)
    project_action(project) != 'N/A'
  end

  def project_action_class(project)
    'action' if %w(quoting synthesizing getting_data).include? project.status
  end

  def project_action_partial(project)
    case project.status
    when 'quoting' then 'set_price'
    when 'synthesizing' then 'advance_to_getting_data'
    when 'getting_data' then 'attach_report_and_finish'
    end
  end

  def status_percentage(project)
    case project.status
    when 'quoting' then '20'
    when 'payment_pending' then '40'
    when 'synthesizing' then '60'
    when 'getting_data' then '80'
    when 'done' then '100'
    end
  end

  def status_color(project)
    case project.status
    when 'quoting' then 'progress-bar-info'
    when 'payment_pending' then 'progress-bar-info'
    when 'done' then 'progress-bar-success'
    end
  end
end
