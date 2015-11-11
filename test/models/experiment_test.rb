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

require 'test_helper'

class ExperimentTest < ActiveSupport::TestCase
  test 'should not save experiment without name' do
    experiment = Experiment.new(price: 15)
    assert_not experiment.save
  end

  test 'should not save experiment without price' do
    experiment = Experiment.new(name: 'Sequencing')
    assert_not experiment.save
  end
end
