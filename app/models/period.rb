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
      Date.today - 1.month
    end
  end
  
  def end_time
    Date.today
  end
  
  def compare_start_time(index)
    index = index + 1
    case self.rule
    when "last_day"
      Date.today - index.day
    when "last_week"
      Date.today - index.week
    when "last_month"
      Date.today - index.month
    end
  end
  
  def to_json
    super(:methods => [:start_time, :end_time, :interval])
  end
  
  def compare?
    self.compare_number > 0
  end

  def template_attributes
    self.attributes.slice("rule", "rate", "compare_number")
  end
  
end