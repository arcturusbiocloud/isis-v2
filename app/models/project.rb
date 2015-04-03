class Project < ActiveRecord::Base
  belongs_to :user
  has_many :activities

  # To create nice URLs
  extend FriendlyId
  friendly_id :name, use: :slugged

  # A project is created with status 0 (pending); then another process grab the
  # project, allocate resources for it and change the status to 1 (running).
  # Lastly, that same process should finish the project, changing its status
  # to 2 (completed)
  enum status: { pending: 0, running: 1, completed: 2 }

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
