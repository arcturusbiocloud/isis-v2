# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  slug          :string           not null
#  description   :string
#  is_public     :boolean          default(TRUE), not null
#  design        :text
#  status        :integer          default(0), not null
#  icon_url_path :string           not null
#  user_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
