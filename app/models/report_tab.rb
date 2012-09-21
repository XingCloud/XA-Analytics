class ReportTab < ActiveRecord::Base
  belongs_to :report
  has_many :dimensions, :dependent => :destroy
  has_many :widgets, :dependent => :destroy
  has_many :report_tab_metrics, :dependent => :destroy, :order => "position ASC"
  has_many :metrics, :through => :report_tab_metrics

  accepts_nested_attributes_for :dimensions, :allow_destroy => true
  accepts_nested_attributes_for :report_tab_metrics, :allow_destroy => true

  validates_presence_of :title, :chart_type, :interval, :length, :compare
  validates_numericality_of :length, :only_integer => true, :greater_than => 0
  validates_numericality_of :compare, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :day_offset, :only_integer => true, :greater_than_or_equal_to => 0

  scope :template, where(:project_id => nil)

  alias_method :original_metric_ids=, :metric_ids=
  alias_method :original_metric_ids, :metric_ids


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
    {:title => title, :chart_type => chart_type, :interval => interval, :length => length, :compare => compare, :show_table => show_table}
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

  def dimensions_sequence
    if dimensions.length > 0
      results = {}
      if dimensions.where(:dimension_type => "USER_PROPERTIES").length > 0
        results[:USER_PROPERTIES] = dimensions.where(:dimension_type => "USER_PROPERTIES").map(&:value)
      end
      if dimensions.where(:dimension_type => "EVENT").length > 0
        results[:EVENT] = dimensions.where(:dimension_type => "EVENT").map{|dimension| dimension.value.to_i}
      end
      results
    else
      nil
    end
  end

  define_method "metric_ids" do
    if id.present?
      report_tab_metrics.map(&:metric_id)
    else
      send("original_metric_ids")
    end

  end

  define_method "metric_ids=" do |arg|
    send("original_metric_ids=", arg)
    arg.length.times do |index|
      rtm = report_tab_metrics.find_by_metric_id(arg[index])
      rtm.update_attributes({:position => index}) unless rtm.blank?
    end
  end

end