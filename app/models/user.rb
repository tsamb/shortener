class User < ActiveRecord::Base
  has_secure_password

  validates :username, uniqueness: true, presence: true
  validates :password, length: {minimum: 8}

  has_many :links
end
