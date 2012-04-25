require "uri"
require "net/http"

class AnalyticService

  BASE_URL = APP_CONFIG[:analytics_base_url]
  REQUEST_ID = UUID.new()

  def self.logger
    unless @logger
      @logger ||= Logger.new(Rails.root.join("log/api_request.log"))
      @logger.formatter = proc { |severity, datetime, progname, msg|
        "#{datetime.strftime("%m-%d %H:%M:%S")}: #{msg}\n"
      }
    end

    @logger
  end

  def request_data(report_tab, params)

    request_params = []
    request_result = {}
    segment_ids = params[:segment_ids]

    if segment_ids.blank? or segment_ids.length == 0
      segment_ids = [nil]
    end

    index = 0

    segment_ids.each do |segment_id|
      report_tab.metrics.each do |metric|
        request_id = REQUEST_ID.generate()
        request_result[request_id] = {
            :metric_id => metric.id,
            :segment_id => segment_id.blank? ? 0 : segment_id,
            :for_compare => false,
            :data => [],
            :index => index,
            :id => "metric_#{metric.id}_segment_#{segment_id.blank? ? '0' : segment_id}_0"
        }
        request_params.push(request_options(request_id, metric.id, segment_id, false, params))
        if params[:compare].to_i != 0
          request_id = REQUEST_ID.generate()
          request_result[request_id] = {
              :metric_id => metric.id,
              :segment_id => segment_id.blank? ? 0 : segment_id,
              :for_compare => true,
              :data => [],
              :index => index,
              :id => "metric_#{metric.id}_segment_#{segment_id.blank? ? '0' : segment_id}_1"
          }
          request_params.push(request_options(request_id, metric.id, segment_id, true, params))
        end
      index = index + 1
      end
    end

    pp request_params

    resp = self.class.commit("/dd/events", {:params => request_params.to_json, :p => 1})
    if resp["result"]
      resp["datas"].keys.each do |request_id|
        request_result[request_id].merge!(resp["datas"][request_id])
      end
    end
    request_result.values
  end

  def self.check_event_key(project, target_row, condition)
    options = {:project_id => project.identifier, :target_row => target_row, :condition => filter_condition(condition, target_row)}

    commit("/dd/evlist", {:params => options.to_json})
  end

  def self.user_attribute(project)
    options = {:project_id => project.identifier}
    commit("/dd/up", {:params => options.to_json})
  end

  private


  def self.filter_condition(condition, target_row)
    condition.each do |k, v|
      if v.blank? || v == "*" || k == target_row
        condition.delete(k)
      end
    end
  end

  def request_options(request_id, metric_id, segment_id, compare, params)
    end_time = (compare ? params[:compare_end_time] : params[:end_time]).to_i
    options = {
        :id => request_id,
        :project_id => params[:identifier],
        :end_time => Time.at(end_time).strftime("%Y-%m-%d"),
        :start_time => Time.at(end_time - (params[:length].to_i - 1) * 86400).strftime("%Y-%m-%d"),
        :interval => params[:interval].upcase
    }

    segment = Segment.find_by_id(segment_id)
    metric = Metric.find_by_id(metric_id)

    options.merge!({:segment => (segment.to_hsh.to_json unless segment.blank?)})
    options.merge!(metric_options(metric))

  end

  def metric_options(metric)
    options = {
        :event_key => metric.event_key,
        :count_method => metric.condition.upcase
    }

    if metric.number_of_day.present?
      options.merge!({:number_of_day => metric.number_of_day})
    end

    if metric.comparison_operator.present?
      options.merge!({:filter => {
          :comparison_operator => metric.comparison_operator.upcase,
          :comparison_value => metric.comparison
      }})
    end

    if combine = metric.combine
      options.merge!({:combine => {
          :action => metric.combine_action.to_s.upcase
      }})
      options[:combine].merge!(metric_options(combine))
    end

    options
  end


  def self.commit(url, options = {}, request_options = {})
    url = URI.parse(File.join(BASE_URL, url))
    pp url
    pp options

    logger.info "Request: #{url} \n #{options.pretty_inspect}"

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