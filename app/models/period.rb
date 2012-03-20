class Period < ActiveRecord::Base
  include Highchart::Period
  belongs_to :report
  
  RULES = ["last_day", "last_week", "last_month"]
  RATES = ["five_min", "one_hour", "one_day", "one_week"]
  INTERVALS = {
    "five_min" => 5 * 60 * 1000,
    "one_hour" => 3600 * 1000,
    "one_day"  => 24 * 3600 * 1000,
    "one_week" => 7 * 24 * 3600 * 1000
  }
  
  validates_presence_of :rule, :rate
  
  def interval
    INTERVALS[self.rate]
  end
  
  def start_time
    case self.rule
    when "last_day"
      Time.now - 1.day
    when "last_week"
      Date.today - 1.week
    when "last_month"
      Date.today - 30.day
    end
  end
  
  def end_time
    Time.now
  end
  
  def to_json
    super(:methods => [:start_time, :end_time])
  end
  
end