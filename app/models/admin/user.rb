####
#
# User
#
# User represents a login into the application
#
# A new user has to be checked for a valid email
# and the password has to be confirmed.
#
#
####
#
class User < ActiveRecord::Base
  enum role: %i[user admin]
  scope :by_nickname, -> { order(:nickname) }

  has_secure_password
  validates :nickname, presence: true
  validates :email, presence: true,
                    format: { with: /\A.*@.*\z/ },
                    uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
  validates :role, inclusion: { in: roles.keys }
end
