class Report < ActiveRecord::Base
  include Highchart::Report
  after_initialize :default_values

  belongs_to :project
  has_many :metrics, :dependent => :destroy
  has_one :period, :dependent => :destroy
  has_many :menu_reports
  has_many :menus, :through => :menu_reports

  accepts_nested_attributes_for :metrics, :allow_destroy => true
  accepts_nested_attributes_for :period

  validates_presence_of :title, :type, :metric_ids, :period

  delegate :rate, :interval, :start_time, :end_time, :compare?, :to => :period
  delegate :identifier, :to => :project

  COMMON_TEMPLATE = 1
  CUSTOM_TEMPLATE = 0

  scope :template, where(:template => COMMON_TEMPLATE)

  def do_public
    self.update_attributes(:public => true)
  end

  def self.type_name
    self.name.demodulize.underscore
  end

  def type_name
    self.class.type_name
  end

  def to_json
    super(:methods => [:type_name])
  end

  def clone_as_template(project_id)
    new_metrics = []
    self.metrics.all.each do |metric|
      new_metric = metric.clone_as_template(project_id)
      if new_metric.save
        new_metrics.push(new_metric.id)
      end
    end
    self.class.new({:title => self.title,
                    :metric_ids => new_metrics,
                    :description => self.description,
                    :period_attributes => self.period.template_attributes,
                    :project_id => project_id})
  end

  private

  def default_values
    self.template ||= 0
  end
end

Dir.glob(File.dirname(__FILE__) + "/reports/*.rb").each do |file|
  require_dependency file
end