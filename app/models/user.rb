class User < ActiveRecord::Base
  has_many :project_users, :dependent=> :destroy
  has_many :projects, :through => :project_users

  def js_attributes
    attributes
  end
end
