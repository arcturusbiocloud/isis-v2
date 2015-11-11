# == Schema Information
#
# Table name: projects
#
#  id                      :integer          not null, primary key
#  name                    :string           not null
#  slug                    :string           not null
#  is_open_source          :boolean          default(TRUE), not null
#  is_featured             :boolean          default(FALSE), not null
#  status                  :integer          default(0), not null
#  icon_url_path           :string           not null
#  user_id                 :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  gen_bank                :string           not null
#  gen_bank_content        :binary           not null
#  price                   :money
#  estimated_delivery_days :integer
#  report                  :string
#  report_content          :binary
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  setup do
    extend ActionDispatch::TestProcess

    @user = users(:one)
    @file = fixture_file_upload('/project_uploader/pithovirus.gb')
  end

  test 'should save project and create an activity' do
    @experiment = experiments(:one)
    project = @user.projects.new(name: 'My project',
                                 gen_bank: @file,
                                 experiments: [@experiment])
    assert project.save
    assert_equal(1, project.activities.count)
  end

  test 'should not save project without title' do
    project = @user.projects.new(gen_bank: @file)
    assert_not project.save
  end

  test 'should not save project without gen_bank' do
    project = @user.projects.new(name: 'My project')
    assert_not project.save
  end
end
