class Period < ActiveRecord::Base
  include Highchart::Period
  belongs_to :report
  
  RULES = ["last_day", "last_week", "last_month"]
  RATES = ["min5", "hour", "day", "week"]
  
  validates_presence_of :rule, :rate
  
  def start_time
    day = case self.rule
    when "last_day"
      Date.today
    when "last_week"
      Date.today.beginning_of_week - 1.week
    when "last_month"
      Date.today.prev_month.beginning_of_month
    end
  end
  
  def end_time
    case self.rule
    when "last_day"
      Date.today
    when "last_week"
      Date.today.end_of_week - 1.week
    when "last_month"
      Date.today.prev_month.end_of_month
    end
  end
  
  def compare_start_time(index)
    total = self.compare_number
    index = self.compare_number - index
    
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