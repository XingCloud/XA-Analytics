class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :users, :through => :user_roles
  has_many :permissions
  has_many :menus, :through => :permissions


  # 创建角色权限
  def create_role_permissions(menus)
    self.menus << Menu.find(menus)
    self.save
  end
  # 编辑角色权限
  def update_role_permissions(menus,menus_id)
    unless menu_ids.blank?
      self.menu_ids = menus_id
    end
    self.update_attributes(menus)

  end
end