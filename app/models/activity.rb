class Activity < ActiveRecord::Base
  belongs_to :project

  enum key: {
    created: 0,
    assembling: 1,
    transforming: 2,
    plating: 3,
    incubating: 4,
    picture_taken: 5,
    completed: 6
  }

  after_create :handle_project_status, :notify

  def background
    case self.key
      when "created" then "cd-green"
      when "assembling" then "cd-running"
      when "transforming" then "cd-movie"
      when "plating" then "cd-plating"
      when "incubating" then "cd-location"
      when "picture_taken" then "cd-picture"
      when "completed" then "cd-green"
    end
  end

  def icon
    case self.key
    when "created" then "fa-clock-o"
      when "assembling" then "fa-random"
      when "transforming" then "fa-flask"
      when "plating" then "fa-eyedropper"
      when "incubating" then "fa-sun-o"
      when "picture_taken" then "fa-picture-o"
      when "completed" then "fa-check-square-o"
    end
  end

  def title
    case self.key
      when "created" then "Project created!"
      when "assembling" then "Assembling"
      when "transforming" then "Transforming"
      when "plating" then "Plating"
      when "incubating" then "Incubating"
      when "picture_taken" then "Picture taken!"
      when "completed" then "Project finished!"
    end
  end

  def description
    case self.key
      when "created" then "<p>Arc just created your project and is going to run it as soon as possible.</p>"
      when "assembling" then "<p>Arc just got all the genetic parts and configurations to assemble your genetic circuit. You can watch the video of the process and learn more about it!</p><p><div id='player'>Loading video...</div></p>"
      when "transforming" then "<p>Arc is transforming a competent cell with your genetic circuit.</p>"
      when "plating" then "<p>Arc is plating your transformed competent cell in a petri dish with agar.</p>"
      when "running" then "<p>Arc just got all the consumables and configurations to start your experiment and now is working for you. This step is going to take approximately 10 minutes to be completed.</p>"
      when "incubating" then "<p>Arc is incubating your experiment for the next 36 hours.</p>"
      when "picture_taken" then "<p>Arc just got a picture of your experiment: <br/><br/><a href='#{self.detail.gsub('t_thumbnail','t_original')}' class='fancybox' rel='gallery1'><img src='#{self.detail}' class: 'img-thumbnail'><p class='lighterbox-title'></a></p>"
      when "completed" then "<p>Arc just finished your experiment. You can check the insights and pictures to see if your genetic circuit is working as expected.</p>"
    end
  end

  private

  def handle_project_status
    case self[:key]
    when Activity.keys[:assembling]
      # This activity indicates that the project is no longer pending,
      # so the project status is updated to 1 (running)
      return project.update_attribute(:status, 1)
    when Activity.keys[:incubating]
      # This activity indicates that the project is ready to be photographed
      return project.update_attribute(:status, 2)
    when Activity.keys[:picture_taken]
      # This activity indicates that a picture was taken, so the project
      # is updated with the current time
      return project.update_attribute(:last_picture_taken_at, Time.now)
    when Activity.keys[:completed]
      # This activity indicates that no further actions will be taken towards
      # ths project, so it is status is updated to 3 (completed)
      project.update_attribute(:status, 3)
    end
  end

  def notify
    return if self.created?

    require 'pusher'

    Pusher.url = Rails.application.secrets.pusher_url

    Pusher[self.project.channel].trigger('update', {
      background: background,
      icon: icon,
      title: title,
      description: description,
      timestamp: self.created_at.strftime('%m/%d/%Y %H:%M:%S')
    })
  end
end

# == Schema Information
#
# Table name: activities
#
#  id         :integer          not null, primary key
#  key        :integer          default(0), not null
#  detail     :string
#  project_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
