require "uri"
require "net/http"

class AnalyticService
  
  BASE_URL = "http://50.22.226.204:8080"
  
  def self.logger
    unless @logger
      @logger ||= Logger.new(Rails.root.join("log/api_request.log"))
      @logger.formatter = proc { |severity, datetime, progname, msg|
        "#{datetime.strftime("%m-%d %H:%M:%S")}: #{msg}\n"
      }
    end
    
    @logger
  end
  
  
  def initialize(options = {})

    @analytic_options = {
      :project_id     => options[:identifier],
      :interval       => options[:rate],
      :start_time     => options[:start_time],
      :end_time       => options[:end_time],
      :compare        => options[:compare]
    }
  end

  def request_metrics_data(metrics)
    metrics_data = {}
    metrics.each do |metric|
      metric_data = self.request_metric_data(metric)
      metrics_data[metric.id.to_sym] = metric_data
    end
    metrics_data
  end

  def self.check_event_key(project, target_row, condition)
    options = {:project_id => project.identifier, :target_row => target_row, :condition => filter_condition(condition, target_row)}
    
    commit("/dd/evlist", {:params => options.to_json })
  end
  
  private

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

  def self.filter_condition(condition, target_row)
    condition.each do |k,v|
      if v.blank? || v == "*" || k == target_row
        condition.delete(k)
      end
    end
  end
  
  def metric_option_of(metric)
    options = {
      :event_key => metric.event_key,
      :count_method => metric.condition.upcase
    }
    
    if metric.number_of_day.present?
      options[:number_of_day] = metric.number_of_day
    end
    
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
    
    logger.info "Request: #{url} \n #{options.pretty_inspect}"
    
    Timeout.timeout(15) do
      response = Net::HTTP.post_form(url, options)
      logger.info "Response: #{response.code}"
      pp response.body
      if response.is_a?(Net::HTTPSuccess)
        return ActiveSupport::JSON.decode(response.body)
      else
        return {"result" => false, "error" => "Request: #{response.code}"}
      end
    end
  end
  
end