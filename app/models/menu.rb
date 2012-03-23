class Menu < ActiveRecord::Base
  acts_as_nested_set :scope => :project_id,:depth => 2
  include MenuSortable

  belongs_to :project

  has_many :menu_reports
  has_many :reports,:through => :menu_reports

  has_many :permissions
  has_many :roles, :through => :permissions

  validates_presence_of :name

  attr_accessor :report_id
  def create_association(report_ids)
    unless report_ids.blank?
      self.reports << Report.find(report_ids)
    end
    self.save
  end

  def update_association(menu,report_ids)
    unless report_ids.blank?
      self.report_ids = report_ids
    end
    self.update_attributes(menu)
  end
  
end
