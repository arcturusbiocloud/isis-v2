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
    return project.update_attribute(:status, 1) if self.assembling?
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
