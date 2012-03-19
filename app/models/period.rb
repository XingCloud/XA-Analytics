class Period < ActiveRecord::Base
  belongs_to :report
  
  RULES = ["last_day", "last_week", "last_month"]
  RATES = ["five_min", "one_hour", "one_day"]
end