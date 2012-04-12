class ReportTab < ActiveRecord::Base
  include Highchart::Report

  belongs_to :report
  has_and_belongs_to_many :metrics

  validates_presence_of :title, :chart_type

  def js_attributes
    attributes.merge({:metrics => metrics.map(&:attributes)})
  end


end