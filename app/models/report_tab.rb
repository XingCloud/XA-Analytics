class ReportTab < ActiveRecord::Base
  belongs_to :report
  has_many :dimensions, :dependent => :destroy
  has_many :widgets, :dependent => :destroy
  has_and_belongs_to_many :metrics

  accepts_nested_attributes_for :dimensions, :allow_destroy => true

  validates_presence_of :title, :chart_type, :interval, :length, :compare
  validates_numericality_of :length, :only_integer => true, :greater_than => 0
  validates_numericality_of :compare, :only_integer => true, :greater_than_or_equal_to => 0

  scope :template, where(:project_id => nil)


  def metrics_attributes
    metrics.map(&:attributes)
  end

  def js_attributes
    attributes.merge({:metric_ids => metric_ids, :dimensions_attributes => dimensions.map(&:attributes)})
  end

  def short_attributes
    {:id => id, :report_id => report_id}
  end

  def template_attributes
    {:title => title, :chart_type => chart_type, :interval => interval, :length => length, :compare => compare}
  end

  def clone_as_template(project_id)
    new_report_tab = ReportTab.new(self.template_attributes)
    new_report_tab.project_id = project_id
    new_report_tab.metrics = self.metrics
    self.dimensions.each do |dimension|
      new_dimension = dimension.clone_as_template()
      new_report_tab.dimensions.push(new_dimension)
    end
    new_report_tab
  end

end