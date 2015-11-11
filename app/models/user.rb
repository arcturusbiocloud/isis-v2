class User < ActiveRecord::Base
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         authentication_keys: [:login]

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  has_many :projects

  enum status: { pending: 0, active: 1, tester: 2, suspended: 3 }

  # To handle gravatars
  include Gravtastic
  gravtastic

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :username,
            presence: true,
            exclusion: { in: proc { User.reserved_usernames } },
            uniqueness: { case_sensitive: false }

  # List the first users of the platform first
  default_scope { order('created_at') }

  # Allow users to sign in using their username or email address
  # https://goo.gl/WCUO2S
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    conditions[:email].downcase! if conditions[:email]

    if login = conditions.delete(:login)
      where(conditions).find_by(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }])
    else
      if conditions[:username].nil?
        find_by(conditions)
      else
        find_by(['lower(username) = :value OR lower(email) = :value', { value: conditions[:username] }])
      end
    end
  end

  def self.reserved_usernames
    @reserved_usernames ||= begin
      file = File.open('lib/support/reserved_usernames.txt')
      usernames = file.each_line.to_a.map(&:chomp)
      file.close
      usernames
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  username               :string           not null
#  status                 :integer          default(1), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE)
#
