require "uri"
require "net/http"

class AnalyticService
  
  BASE_URL = "http://50.22.226.204:8080"
  
  def initialize(report, options = {})
    
    @report = report
    
    @analytic_options = {
      :project_id     => @report.identifier, #@report.project_id,
      :interval       => @report.rate.upcase,
      :start_time     => options[:start_time],
      :end_time       => options[:end_time],
      :compare        => @report.compare?
    }
  end
  
  def request_metric_data(metric)
    options = @analytic_options.merge metric_option_of(metric)
    
    # if have combine operation
    if combo = metric.combine
      options.merge!({
        :combine => {
          :action => metric.combine_action.to_s.upcase
        }.merge(metric_option_of(combo))
      })
    end
    
    pp options
    
    self.class.commit("/dd/event", {:params => options.to_json, :p => 1})
  end
  
  def self.events(project, page = 1)
    params = {
      :project_id => project.identifier,
      :idx => page,
      :pagesize => 50
    }
    
    commit("/dd/evlist", params)
  end
  
  private
  
  def metric_option_of(metric)
    options = {
      :event_key => metric.event_key,
      :count_method => metric.condition.upcase
    }
    
    options.merge!({
      :filter => {
        :comparison_operator => metric.comparison_operator.upcase,
        :comparison_value => metric.comparison
      }
    }) if metric.comparison_operator.present?
    
    options
  end
  
  
  def self.commit(url, options = {}, request_options = {})
    url = URI.parse( File.join(BASE_URL, url) )
    pp url
    pp options
    response = Net::HTTP.post_form(url, options)
    
    pp response.body
    if response.is_a?(Net::HTTPSuccess)
      ActiveSupport::JSON.decode(response.body)
    else
      {"result" => false, "error" => "Request: #{response.code}"}
    end
    
  end
  
  def parse_data(resp)
    
  end
  
end