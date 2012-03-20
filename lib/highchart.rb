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
    
    def to_xaxis_option
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

      options["tickInterval"] = case self.rate
      when "five_min"
        5 * 60 * 1000
      when "one_hour"
        3600 * 1000
      when "one_day"
        24 * 3600 * 1000
      when "one_week"
        7 * 24 * 3600 * 1000
      end

      options
    end
    
  end
end