class Menu < ActiveRecord::Base
  belongs_to :project

  has_many :menu_reports, :dependent => :destroy
  has_many :reports, :through => :menu_reports

  acts_as_nested_set :scope => [:project_id, :parent_id], :depth => 2

  include MenuSortable

  validates_presence_of :name

  attr_accessor :report_id

  STATUS_DEFAULT = 0 #　默认菜单模板
  STATUS_CUSTOM = 1 #　自定义菜单

  scope :template, where(:status => STATUS_DEFAULT)


  def create_association(report_ids)
    menu = Menu.create(:name=>self.name,:desc => self.desc,:project_id => self.project_id)
    unless self.parent_id.blank?
      parent = Menu.find(self.parent_id)
      menu.move_to_child_of(parent)
    end

    unless report_ids.blank?
      menu.reports << Report.find(report_ids)
    end
  end

  def update_association(menu, report_ids)
    self.update_attributes(:name=>menu[:name],:desc => menu[:desc])
    unless menu[:parent_id].blank?
      parent = Menu.find(menu[:parent_id])
      #self.move_to_child_of(parent)
    end
    unless report_ids.blank?
      self.report_ids = report_ids
    end

  end

end
