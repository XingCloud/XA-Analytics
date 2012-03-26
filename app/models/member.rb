class Member < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :member_roles
  has_many :roles,:through => :member_roles
end
