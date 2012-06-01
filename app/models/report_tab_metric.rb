class ReportTabMetric < ActiveRecord::Base
  belongs_to :report_tab
  belongs_to :metric

  validates_presence_of :report_tab_id, :metric_id, :position
  validates_numericality_of :position, :only_integer => true, :greater_than_or_equal_to => 0
end