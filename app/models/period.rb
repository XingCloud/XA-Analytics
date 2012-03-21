class Period < ActiveRecord::Base
  include Highchart::Period
  belongs_to :report
  
  RULES = ["last_day", "last_week", "last_month"]
  RATES = ["min5", "hour", "day", "week"]
  
  validates_presence_of :rule, :rate
  
  def start_time
    day = case self.rule
    when "last_day"
      Date.yesterday
    when "last_week"
      Date.today - 1.week
    when "last_month"
      Date.today - 30.day
    end
  end
  
  def end_time
    Date.today
  end
  
  def to_json
    super(:methods => [:start_time, :end_time])
  end
  
end