class User < ActiveRecord::Base
 devise :database_authenticatable,
        :registerable,
        :recoverable,
        :rememberable,
        :trackable,
        :validatable,
        :authentication_keys => [:login]

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  has_many :projects

  validates :email,
    presence: true,
    uniqueness: {
      case_sensitive: false
    }

  validates :username,
    presence: true,
    uniqueness: {
      case_sensitive: false
    }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    conditions[:email].downcase! if conditions[:email]

    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
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
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
