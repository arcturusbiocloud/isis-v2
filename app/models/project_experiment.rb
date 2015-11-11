# == Schema Information
#
# Table name: project_experiments
#
#  id            :integer          not null, primary key
#  project_id    :integer          not null
#  experiment_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ProjectExperiment < ActiveRecord::Base
  belongs_to :project
  belongs_to :experiment
end
