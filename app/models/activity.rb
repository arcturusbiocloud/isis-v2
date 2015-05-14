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
    I18n.t("timeline.background.#{key}")
  end

  def icon
    # Font-awesome icons to represent the different stages of the project,
    # displayed on the timeline. Note that the icon 'fa-random' is used
    # on the JavaScript to trigger the assembling video, so if it is changed
    # here, the script on projects/show.html.erb should be changed as well.
    I18n.t("timeline.icon.#{key}")
  end

  def title
    I18n.t("timeline.title.#{key}")
  end

  def description(index=nil)
    if picture_taken?
      link = detail.gsub('t_thumbnail/','')
      I18n.t("timeline.description.#{key}", link: link, i: index, img: detail)
    else
      I18n.t("timeline.description.#{key}")
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
      # is updated with the current time. If this is the nth picture, the
      # completed activity is automatically triggered
      project.activities.create!(key: 6) if project.can_be_closed?
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
      description: description(project.activities.picture_taken.count),
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
