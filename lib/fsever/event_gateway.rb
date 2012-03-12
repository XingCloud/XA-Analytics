module Fserver
  class EventGateway < Gateway
    
    
    def paginate(page, project)
      get_response("/events", :params => {:page => page})
    end
    
    protected
    
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
