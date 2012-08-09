require "uri"
require "net/http"

class AnalyticService
  BASE_URL = APP_CONFIG[:analytics_base_url]

  def self.logger
    unless @logger
      @logger ||= Logger.new(Rails.root.join("log/api_request.log"))
      @logger.formatter = proc { |severity, datetime, progname, msg|
        "#{datetime.strftime("%m-%d %H:%M:%S")}: #{msg}\n"
      }
    end

    @logger
  end

  def self.request_data(project, params)
    results = []
    resp = commit("/dd/query", build_params(project, params))
    if resp["result"]
      resp["datas"].keys.each do |id|
        results.append(resp["datas"][id].merge({"id" => id}))
      end
    end
    {:results => results, :status => resp["status"].blank? ? 200 : resp["status"]}
  end

  def self.request_dimensions(project, params)
    resp = commit('/dd/query', build_params(project, params))
    results = resp["result"] ? resp : {}
    {:results => results, :status => resp["status"].blank? ? 200 : resp["status"]}
  end

  def self.check_event_key(project, target_row, condition)
    options = {:project_id => filter_project_id(project), :target_row => target_row, :condition => filter_condition(condition, target_row)}
    commit("/dd/evlist", {:params => options.to_json})
  end

  def self.ups(project)
    options = {:project_id => filter_project_id(project)}
    resp = commit("/dd/up", options)
    if resp["result"]
      resp["data"]
    else
      []
    end
  end

  def self.sync_user_attribute(project, params)
    {:status => commit('/dd/cup', build_params(project, params))["result"] ?  200 : 500}
  end

  def self.sync_user_attributes(project)
    resp = commit('/dd/cup', {:type => "LIST", :project_id => filter_project_id(project)})
    if resp["result"].kind_of?(Array)
      {:status => 200, :results => resp["result"]}
    else
      {:status => 500}
    end
  end

  def self.sync_metric(action, metrics)
    request = {
      :type => action,
      :params => metrics.to_json
    }
    resp = commit("/dd/sync", request)
    if resp["result"]
      resp["cnt"]
    else
      nil
    end
  rescue Exception => e
    logger.error "sync metrics #{metrics.to_json} error: #{e.message}"
    nil
  end

  private


  def self.filter_condition(condition, target_row)
    condition.each do |k, v|
      if v.blank? || v == "*" || k == target_row
        condition.delete(k)
      end
    end
  end

  def self.filter_project_id(project)
    if APP_CONFIG[:demo].present? and APP_CONFIG[:demo].keys.index(project.identifier).present?
      APP_CONFIG[:demo][project.identifier]
    else
      project.identifier
    end
  end

  def self.build_params(project, params)
    requests = JSON.parse(params[:params])
    requests.each do |request|
      request["project_id"] = filter_project_id(project)
    end
    params[:params] = requests.to_json
    params
  end

  def self.commit(url, options = {})
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
      return {"result" => false, "status" => 500}
    end
  end
end