module Redmine
  class ProjectGateway < Gateway
    
    def initialize(options = {})
      @options = options
    end
    
    def paginate(page)
      get_response("/project_services", :params => {:page => page})
    end
    
    private
    
    def get_response(url, options = {})
      params = options[:params] || {}
      
      full_url = File.join(HOST, url)
      if params.blank?
        full_url << "?token=#{TOKEN}"
      else
        full_url << "?#{params.to_query}&token=#{TOKEN}"
      end
      
      pp full_url
      http_resp = Net::HTTP.get(URI.parse(full_url))
      
      response = Response.new(http_resp)
      
      unless response.success?
        error(response.error)
      end
      
      response
    end    
  end
end