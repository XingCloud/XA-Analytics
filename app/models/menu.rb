class Menu < ActiveRecord::Base
  acts_as_nested_set :scope => :project_id,:depth => 2
  include MenuSortable

  belongs_to :project

  has_many :menu_reports
  has_many :reports,:through => :menu_reports

  validates_presence_of :name

  attr_accessor :report_id

  STATUS_DEFAULT = 0 #　默认菜单模板
  STATUS_CUSTOM = 1  #　自定义菜单

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
