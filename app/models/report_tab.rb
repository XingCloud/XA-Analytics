class ReportTab < ActiveRecord::Base
  belongs_to :report
  has_and_belongs_to_many :metrics
  validates_presence_of :title, :chart_type, :interval, :length, :compare


  def metrics_attributes
    metrics.map(&:attributes)
  end

  def js_attributes
    attributes.merge({:metric_ids => metric_ids})
  end

  def short_attributes
    {:id => id, :title => title}
  end
end