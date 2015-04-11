# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  name                  :string           not null
#  slug                  :string           not null
#  description           :string
#  is_open_source        :boolean          default(TRUE), not null
#  is_featured           :boolean          default(FALSE), not null
#  status                :integer          default(0), not null
#  icon_url_path         :string           not null
#  last_picture_taken_at :datetime
#  recording_file_name   :string
#  anchor                :string
#  promoter              :string
#  rbs                   :string
#  gene                  :string
#  terminator            :string
#  cap                   :string
#  user_id               :integer          not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
