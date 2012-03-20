class User < ActiveRecord::Base
  has_many :projects
  has_many :user_roles
  has_many :roles, :through => :user_roles

  def role?(role)
    return !!self.roles.find_by_name(role.to_s)
  end

  def asign_role(role)
    self.roles << Role.find(role)
    self.save
  end

  def menus
    menus = []
    if self.admin?
      menus << Menu.all
    else
      self.roles.each do |role|
        menus << role.menus
      end
    end
    menus.flatten
  end

end