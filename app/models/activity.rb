class Activity < ActiveRecord::Base
  belongs_to :project

  enum key: { created: 0, running: 1, incubating: 2, picture_taken: 3, completed: 4 }

  after_create :handle_project_status

  private

  def handle_project_status
    return project.update_attribute(:status, 1) if self.running?
    project.update_attribute(:status, 2) if self.completed?
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
