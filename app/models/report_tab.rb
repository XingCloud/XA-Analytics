class ReportTab < ActiveRecord::Base
  include Highchart::Report

  belongs_to :report
  has_and_belongs_to_many :metrics


end
