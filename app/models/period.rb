class Period < ActiveRecord::Base
  include Highchart::Period
  belongs_to :report
  
  RULES = ["last_day", "last_week", "last_month"]
  RATES = ["five_min", "one_hour", "one_day", "one_week"]
  
  validates_presence_of :rule, :rate
  
end