class ReportCategory < ActiveRecord::Base
  has_many :project_report_categories, :dependent => :destroy
  has_many :projects, :through => :project_report_categories
  has_many :reports

  validates_presence_of :name

  scope :template, where(:project_id => nil)

  def short_attributes
    {:id => id, :name => name, :position => position}
  end

  def js_attributes
    attributes
  end

  def merge_join_attributes(project_report_category)
    (self.name = project_report_category.name) unless project_report_category.name.blank?
    (self.position= project_report_category.position) unless project_report_category.position.blank?
    self
  end

end
