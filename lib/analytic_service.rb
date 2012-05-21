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
            :segment_id => segment_id.blank? ? 0 : segment_id.to_i,
            :for_compare => false,
            :data => [],
            :index => index,
            :filters => (params[:filters].present? ? params[:filters].map{|item|item[1]} : []),
            :id => "metric_#{metric.id}_segment_#{segment_id.blank? ? '0' : segment_id}_0"
        }
        request_params.push(request_options(request_id, metric.id, segment_id, false, params))
        if params[:compare].to_i != 0
          request_id = REQUEST_ID.generate()
          request_result[request_id] = {
              :metric_id => metric.id,
              :segment_id => segment_id.blank? ? 0 : segment_id.to_i,
              :for_compare => true,
              :data => [],
              :index => index,
              :filters => (params[:filters].present? ? params[:filters].map{|item|item[1]} : []),
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
      request_result.values
    end
  end

  def self.check_event_key(project, target_row, condition)
    options = {:project_id => project.identifier, :target_row => target_row, :condition => filter_condition(condition, target_row)}

    commit("/dd/evlist", {:params => options.to_json})
  end

  def self.user_attributes(project)
    options = {:project_id => project.identifier}
    commit("/dd/up", options)
  end


  def request_dimensions(report_tab, params)
    result = {:data => [], :total => 0, :pagesize => 0, :index => 0, :rate => 0.0, :cost => 0}
    options = []
    report_tab.metrics.each do |metric|
      options.push(request_dimension_options(metric, params))
    end
    pp options
    index = params[:index].present? ? params[:index].to_i : 0
    pagesize = (params[:pagesize].present? and params[:pagesize].to_i != 0) ? params[:pagesize].to_i : 10
    resp = self.class.commit('/dd/event/groupby', {:params => options.to_json,
                                                   :index => index,
                                                   :pagesize => pagesize,
                                                   :orderby => params[:orderby],
                                                   :order => params[:order].blank? ? 'ASC' : params[:order].upcase,
                                                   :filter => params[:query]})
    if resp["result"]
      result.merge!(resp)
    end
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
    request_metric_options(metric_id, params, options)
    request_segment_options(segment_id, params, options)
  end

  def request_dimension_options(metric, params)
    end_time = params[:end_time].to_i
    options = {
        :id => metric.id.to_s,
        :project_id => params[:identifier],
        :end_time => Time.at(end_time).strftime("%Y-%m-%d"),
        :start_time => Time.at(end_time - (params[:length].to_i - 1) * 86400).strftime("%Y-%m-%d"),
        :interval => params[:interval].upcase,
        :groupby => params[:dimension][:value],
        :groupby_type => params[:dimension][:dimension_type].upcase
    }
    request_metric_options(metric.id, params, options)
    request_segment_options(params[:segment_id], params, options)
  end

  def request_segment_options(segment_id, params, options)
    segment = Segment.find_by_id(segment_id)
    if segment.present?
      if options[:segment].present?
        options[:segment].merge!(segment.to_hsh)
      else
        options[:segment] = segment.to_hsh
      end
      if options[:combine].present? and options[:combine][:segment].present?
        options[:combine][:segment].merge!(segment.to_hsh)
      elsif options[:combine].present? and options[:combine][:segment].blank?
        options[:combine][:segment] = segment.to_hsh
      end
    end
    request_filter_user_attributes(params[:filters], options)
    if options[:segment].present?
      options[:segment] = options[:segment].to_json
    end
    if options[:combine].present? and options[:combine][:segment].present?
      options[:combine][:segment] = options[:combine][:segment].to_json
    end
    options
  end

  def request_filter_user_attributes(filters, options)
    if filters.present?
      filters = filters.map{|item|item[1]}
      filters.each do |filter|
        dimension = Dimension.new(filter["dimension"])
        if dimension.dimension_type.upcase == 'USER_PROPERTIES'
          if options[:segment].present?
            options[:segment].merge!(dimension.to_hsh(filter["value"]))
          else
            options[:segment] = dimension.to_hsh(filter["value"])
          end
          if options[:combine].present? and options[:combine][:segment].present?
            options[:combine][:segment].merge!(dimension.to_hsh(filter["value"]))
          elsif options[:combine].present? and options[:combine][:segment].blank?
            options[:combine][:segment] = dimension.to_hsh(filter["value"])
          end
        end
      end
    end
  end

  def request_filter_event(metric, filters)
    if filters.present?
      filters = filters.map{|item|item[1]}
      filters.each do |filter|
        dimension = Dimension.new(filter["dimension"])
        if dimension.dimension_type.upcase == "EVENT"
          metric.send("event_key_"+dimension.value+"=", filter["value"])
        end
      end
    end
    metric
  end

  def request_metric_options(metric_id, params, options)
    metric = Metric.find_by_id(metric_id)
    request_filter_event(metric, params[:filters])
    options.merge!({:event_key => metric.event_key,
                    :count_method => metric.condition.upcase})

    if metric.number_of_day.present?
      options.merge!({:number_of_day => metric.number_of_day})
    end

    if metric.number_of_day_origin.present?
      options.merge!({:number_of_day_origin => metric.number_of_day_origin})
    end

    if metric.segment_id.present?
      segment = Segment.find_by_id(metric.segment_id)
      if segment.present? and options[:segment].present?
        options[:segment].merge!(segment.to_hsh)
      elsif segment.present? and options[:segment].blank?
        options.merge!({:segment => segment.to_hsh})
      end
    end

    if combine = metric.combine
      options.merge!({:combine => {
          :action => metric.combine_action.to_s.upcase
      }})
      request_metric_options(combine.id, params, options[:combine])
    end
  end

  def self.commit(url, options = {}, request_options = {})
    logger.info "Request: #{url} \n #{options.pretty_inspect}"
    pp options

    url = URI.parse(File.join(BASE_URL, url))
    pp url

    response = Net::HTTP.post_form(url, options)

    logger.info "Response Code: #{response.code}"
    pp response.body

    if response.is_a?(Net::HTTPSuccess)
      return JSON.parse(response.body)
    else
      return {"result" => false, "error" => "Request: #{response.code}"}
    end
  end

end