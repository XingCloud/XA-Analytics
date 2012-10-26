require "uri"
require "cgi"
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
    ret = {}
    resp = commit("/dd/query", build_params(project, params))
    results = []
    if resp["result"]
      resp["datas"].keys.each do |id|
        results.append(resp["datas"][id].merge({"id" => id}))
      end
    else
      ret.merge!({:err_code => resp["err_code"], :err_msg => resp["err_msg"]})
    end
    ret.merge!({:results => results, :status => resp["status"].blank? ? 200 : resp["status"]})
    ret
  end

  def self.request_dimensions(project, params)
    ret = {}
    resp = commit('/dd/query', build_params(project, params))
    results = resp["result"] ? resp : {}
    if not resp["result"]
      ret.merge!({:err_code => resp["err_code"], :err_msg => resp["err_msg"]})
    end
    ret.merge!({:results => results, :status => resp["status"].blank? ? 200 : resp["status"]})
    ret
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
    resp = commit('/dd/cup', build_params(project, params))
    if not resp["result"]
      raise resp.to_json
    end
  end

  def self.sync_user_attributes(project)
    resp = commit('/dd/cup', {:type => "LIST", :project_id => filter_project_id(project)})
    if resp["result"].kind_of?(Array)
      resp["result"]
    else
      raise resp.to_json
    end
  end

  def self.sync_metric(action, metrics)
    request = {
      :type => action,
      :params => metrics.to_json
    }
    resp = commit("/dd/sync", request)
    if not resp["result"]
      raise resp.to_json
    end
  end

  def self.sync_segments(action, segments, project)
    segments_map = {}
    segments.each do |segment|
      segments_map[segment.id] = segment.sequence.to_json
    end
    commit('/dd/seg', {:type => action, :params => {
        :project_id => (filter_project_id(project) unless project.blank?),
        :segments => segments_map
    }.to_json})
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

    start_time = Time.now
    req = Net::HTTP::Post.new(url.request_uri)
    req.form_data = safe_escape(options)
    req.basic_auth url.user, url.password if url.user
    req["Accept-Encoding"] = 'gzip,deflate,sdch'
    response = Net::HTTP.new(url.hostname, url.port).start {|http|
      http.request(req)
    }

    if response[ 'Content-Encoding' ].eql?( 'gzip' ) then
      sio = StringIO.new( response.body )
      gz = Zlib::GzipReader.new( sio )
      page = gz.read()
      response.body=page
    end

=begin
    response = Net::HTTP.post_form(url, safe_escape(options))
=end

    end_time = Time.now
    logger.info "Response Code: #{response.code}"
    logger.info "Response Time: #{(end_time - start_time)*1000}ms"

    pp "response.body: #{response.body}"

    if response.is_a?(Net::HTTPSuccess)
      return JSON.parse(response.body)
    else
      return {"result" => false, "status" => 500}
    end
  end

  def self.safe_escape(options)
    if options.is_a?(Hash)
      options.each do |k,v|
        options[k] = safe_escape(v)
      end
    elsif options.is_a?(String)
      CGI.escape(options)
    else
      options
    end
  end
end