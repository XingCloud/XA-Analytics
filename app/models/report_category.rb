class ReportCategory < ActiveRecord::Base

  has_many :reports

  validates_presence_of :name

  scope :template, where(:project_id => nil)

  def short_attributes
    {:id => id, :name => name, :position => position}
  end

  def js_attributes
    attributes.merge({:reports => reports.map(&:short_attributes)})
  end

end
