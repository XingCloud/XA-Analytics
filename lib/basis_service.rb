require "uri"
require "net/http"

class BasisService
  
  HOST  = APP_CONFIG[:basis][:host]
  PORT    = APP_CONFIG[:basis][:port]
  BASIC_USERNAME = APP_CONFIG[:basis][:basic_username]
  BASIC_PASSWORD = APP_CONFIG[:basis][:basic_password]
  
  def self.base_url
    URI::HTTP.build({:host => HOST, :port => PORT}).to_s
  end
  
  def self.find_project(identifier)
    req = Net::HTTP::Get.new("/projects/#{identifier}")
    req.basic_auth BASIC_USERNAME, BASIC_PASSWORD
    
    res = Net::HTTP.start(HOST, PORT) {|http|
      http.request(req)
    }
    
    pp res.body
    if res.is_a?(Net::HTTPSuccess)
      JSON.parse(res.body)
    else
      puts "#{res.code} #{res.message}"
      nil
    end
  end
  
end