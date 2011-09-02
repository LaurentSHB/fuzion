class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def is_admin?
    self.role == "admin"
  end

  def is_super_admin?
    self.role == "super_admin"
  end

  def is_admin_or_super_admin?
    self.is_admin? || self.is_super_admin?
  end
end
