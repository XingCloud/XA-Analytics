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

  def request_data(params)
    pp params
    results = []
    resp = self.class.commit("/dd/events", params)
    if resp["result"]
      resp["datas"].keys.each do |id|
        results.append(resp["datas"][id].merge({"id" => id}))
      end
    end
    results
  end

  def request_dimensions(params)
    pp params
    resp = self.class.commit('/dd/event/groupby', params)
    if resp["result"]
      resp
    else
      {}
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

  private


  def self.filter_condition(condition, target_row)
    condition.each do |k, v|
      if v.blank? || v == "*" || k == target_row
        condition.delete(k)
      end
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