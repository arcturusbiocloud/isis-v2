class ProjectMailer < ApplicationMailer
  def quoting_email(project)
    @project = project
    subject = "Project #{@project.id} - #{@project.name}"
    mail(to: 'staff@arcturus.io', subject: subject)
  end

  def payment_pending_email(project)
    @project = project
    subject = "Arcturus BioCloud - #{@project.name}"
    mail(to: @project.user.email, subject: subject)
  end

  def synthesizing_email(project)
    @project = project
    subject = "Project #{@project.id} - #{@project.name}"
    mail(to: 'staff@arcturus.io', subject: subject)
  end

  def getting_data_email(project)
    @project = project
    subject = "Arcturus BioCloud - #{@project.name}"
    mail(to: @project.user.email, subject: subject)
  end

  def done_email(project)
    @project = project
    subject = "Arcturus BioCloud - #{@project.name}"
    mail(to: @project.user.email, subject: subject)
  end
end
