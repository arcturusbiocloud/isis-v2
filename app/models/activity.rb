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

  after_create :handle_project_status

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
