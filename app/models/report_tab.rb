class ReportTab < ActiveRecord::Base
  belongs_to :report
  has_many :dimensions, :dependent => :destroy
  has_and_belongs_to_many :metrics

  accepts_nested_attributes_for :dimensions, :allow_destroy => true

  validates_presence_of :title, :chart_type, :interval, :length, :compare


  def metrics_attributes
    metrics.map(&:attributes)
  end

  def js_attributes
    attributes.merge({:metric_ids => metric_ids, :dimensions_attributes => dimensions.map(&:attributes)})
  end

  def short_attributes
    {:id => id, :title => title}
  end

  def template_attributes
    {:title => title, :chart_type => chart_type, :interval => interval, :length => length, :compare => compare}
  end

  def clone_as_template(project_id)
    new_report_tab = ReportTab.new(self.template_attributes)
    new_report_tab.project_id = project_id
    self.metrics.each do |metric|
      new_metric = metric.clone_as_template(project_id)
      new_report_tab.metrics.push(new_metric)
    end
    self.dimensions.each do |dimension|
      new_dimension = dimension.clone_as_template()
      new_report_tab.dimensions.push(new_dimension)
    end
    if new_report_tab.save
      new_report_tab
    else
      raise ActiveRecord::Rollback
    end
  end

end