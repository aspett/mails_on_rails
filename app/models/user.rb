class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :username

  validates_presence_of :password, :on => :create
  validates_presence_of :role, :on => :create
  validate :valid_role_name?

  def is_manager?
    self.role == "Manager"
  end
  private

  def valid_role_name?
    unless ["Clerk", "Manager"].include? self.role
      errors.add(:role, "invalid role name")
    end
  end
end
