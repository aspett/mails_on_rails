class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :username

  validates_presence_of :password, :on => :create
  validates_presence_of :role, :on => :create
end
