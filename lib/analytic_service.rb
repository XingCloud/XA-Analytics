class AnalyticService
  
  def initialize(report, options = {})
    @report = report
    
    
    @analytic_options = {
      :project_id     => @report.project_id,
      :interval       => @report.interval,
      :start_time     => @report.start_time,
      :end_time       => Time.now,
    }.merge!(options)
  end
  
  def request_metric_data(metric)
    options = @analytic_options.merge metric.request_option
    
    if combo = metric.combine
      combine_options = {
        :combine => {
          :action => metric.combine_action
        }.merge(combo.request_option)
      }
      
      options.merge! combine_options
    end
    
    options
  end
  
end