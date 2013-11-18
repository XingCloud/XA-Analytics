class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible  :name, :email, :password, :password_confirmation, :remember_me
  has_many :project_users, :dependent=> :destroy
  has_many :projects, :through => :project_users

  validates_uniqueness_of :name

  def js_attributes
    attributes
  end
end
