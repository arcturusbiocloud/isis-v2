class Project < ActiveRecord::Base
  belongs_to :user
  has_many :activities

  # To create nice URLs
  extend FriendlyId
  friendly_id :name, use: :slugged

  # A project is created with status 0 (pending); then the background job grabs
  # the project, allocate resources for it and change the status to 1 (running).
  # During the running phase, the robot performs various tasks, and at a certain
  # point, the status is changed again, and the new status (2) indicates the
  # project is incubating and ready to be photographed. After 36 pictures, the
  # status is changed to 3 indicating that it is completed.
  enum status: { pending: 0, running: 1, incubating: 2, completed: 3 }

  validates :name,
            presence: true,
            length: { maximum: 25 },
            uniqueness: { scope: :user,
                          message: "Already exists on your account" }

  validates :description, length: { maximum: 80 }

  # List the pending projects first
  default_scope { order('status, created_at DESC') }

  # Projects qualified to be shown on /explore
  scope :is_public, -> { where("is_public = 'true'") }

  # Projects incubating where the last picture was taken one hour ago and
  # with less than 36 pictures in total.
  # Note that the having clause is using count < 41, that's because before
  # stating taking picture, five other activities happens, so 5 + 36 = 41.
  scope :active, -> {
    select("projects.*, COUNT(activities.id)").
     joins("JOIN activities ON activities.project_id = projects.id").
     where("projects.status = 2").
     where("projects.last_picture_taken_at > NOW() - INTERVAL '60 minutes'
            OR projects.last_picture_taken_at IS NULL").
     group("projects.id").
    having("COUNT(activities.id) < 41")
  }

  before_create :random_icon

  private

  def random_icon
    self.icon_url_path = "project-icons/#{rand(15)}.png"
  end
end

# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  name                  :string           not null
#  slug                  :string           not null
#  description           :string
#  is_public             :boolean          default(TRUE), not null
#  design                :text
#  status                :integer          default(0), not null
#  icon_url_path         :string           not null
#  last_picture_taken_at :datetime
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
