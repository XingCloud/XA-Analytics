class ReportCategory < ActiveRecord::Base

  has_many :reports

  COMMON_TEMPLATE = 1
  CUSTOM_TEMPLATE = 0

  scope :template, where(:template => COMMON_TEMPLATE)
end
