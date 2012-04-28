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

  def self.auth_project(identifier, user)
    req = Net::HTTP::Get.new("/projects/#{identifier}/users/#{user}/roles")
    req.basic_auth BASIC_USERNAME, BASIC_PASSWORD
    res = Net::HTTP.start(HOST, PORT){|http|
      http.request(req)
    }
    pp res.body
    if res.is_a?(Net::HTTPSuccess)
      result = JSON.parse(res.body)
      if result.length == 0
        nil
      else
        YAML::load(result[0]["role"]["permissions"])
      end
    else
      puts "#{res.code} #{res.message}"
      nil
    end

  end
  
end