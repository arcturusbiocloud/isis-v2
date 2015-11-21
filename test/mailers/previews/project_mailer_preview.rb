# Preview all emails at http://localhost:3000/rails/mailers/project_mailer
class ProjectMailerPreview < ActionMailer::Preview

  def quoting_email
    ProjectMailer.quoting_email Project.first
  end

  def payment_pending_email
    ProjectMailer.payment_pending_email Project.first
  end

  def synthesizing_email
    ProjectMailer.synthesizing_email Project.first
  end

  def getting_data_email
    ProjectMailer.getting_data_email Project.first
  end

  def done_email
    ProjectMailer.done_email Project.first
  end
end
