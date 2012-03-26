class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :members
  has_many :projects,:through => :members

  def role?(role)
    return false if self.roles.blank?
    return !!self.roles.find_by_name(role.to_s)
  end

  # 分配权限
  def asign_role(role_ids)
    self.roles << Role.find(role_ids)
    self.save
  end

  # 编辑权限
  def update_role(role_ids)
    unless role_ids.blank?
      self.role_ids = role_ids
      self.save
    end
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