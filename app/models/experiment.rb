# == Schema Information
#
# Table name: experiments
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  price      :money            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Experiment < ActiveRecord::Base
  has_many :project_experiments, dependent: :destroy
  has_many :projects, through: :project_experiments

  validates :name,
            presence: true,
            uniqueness: { message: 'Already exists' }

  validates :price, presence: true
end
