class Menu < ActiveRecord::Base
  belongs_to :project
  
  has_many :menu_reports, :dependent => :destroy
  has_many :reports, :through => :menu_reports
  
  acts_as_nested_set :scope => [:project_id, :parent_id], :depth => 2
  
  include MenuSortable

  validates_presence_of :name

  attr_accessor :report_id
  
  STATUS_DEFAULT = 0 #　默认菜单模板
  STATUS_CUSTOM = 1  #　自定义菜单
  
  scope :template, where(:status => STATUS_DEFAULT)

  
  def create_association(report_ids)
    unless report_ids.blank?
      self.reports << Report.find(report_ids)
    end
    self.save!
  end

  def update_association(menu,report_ids)
    unless report_ids.blank?
      self.report_ids = report_ids
    end
    self.update_attributes(menu)
  end
  
end
