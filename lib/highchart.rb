module Highchart
  
  module Report
    
    def series
      self.metrics.map(&:to_serial)
    end
    
  end
  
  module Metric
    def to_serial
      {
  			name: self.name.to_s,
  			lineWidth: 4,
  			marker: {
  				radius: 4
  			}
  		
  		}
    end
    
  end
  
  module Period
    
    def interval
      case self.rate
      when "min5"
        5 * 60
      when "hour"
        3600
      when "day"
        24 * 3600
      when "week"
        7 * 24 * 3600
      end
    end
    
    def xaxis_option
      options = {
        :labels => {
          :align => "left",
          :x => 3,
          :y => -3
        },
        :gridLineWidth => 1,
        :tickWidth => 0
      }
      
      if ["five_min", "one_hour"].include?(self.rate)
        options[:type] = "datetime"
      else
        options[:type] = "date"
      end
      

      options
    end
    
  end
end