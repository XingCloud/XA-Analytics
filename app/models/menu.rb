class Menu < ActiveRecord::Base
  belongs_to :project

  has_many :menu_reports #:dependent => :destroy
  has_many :reports, :through => :menu_reports

  acts_as_nested_set :scope => [:project_id, :status]

  include MenuSortable

  validates_presence_of :name

  attr_accessor :report_id

  STATUS_DEFAULT = false
  STATUS_CUSTOM = true

  scope :template, where(:status => STATUS_DEFAULT)

  scope :parent_menus, where(:status => STATUS_DEFAULT,:parent_id => nil)

  scope :project_menus, lambda {|project| {:conditions => ["project_id = ? and parent_id is null " ,project.id ]}}
  def create_association(report_ids)
    menu = Menu.create(:status => self.status, :name=>self.name, :desc => self.desc, :project_id => self.project_id)
    unless self.parent_id.blank?
      parent = Menu.find_by_id(self.parent_id)
      menu.move_to_child_of(parent)
    end
    
    unless report_ids.blank?
      menu.reports << Report.find(report_ids)
    end
    menu
  end

  def update_association(menu, reports)
    menu = Menu.new(menu.merge(:status => self.status))
    if menu[:parent_id].blank?
      menu.parent_id = self.parent_id
    end
    if reports.blank?
      reports = self.report_ids
    end
    menu.create_association(reports)
    self.destroy
    menu
  end

end
