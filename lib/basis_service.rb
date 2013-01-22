require "uri"
require "net/http"

class BasisService
  
  HOST  = APP_CONFIG[:basis][:host]
  PORT    = APP_CONFIG[:basis][:port]
  SSL_PORT = APP_CONFIG[:basis][:ssl_port]
  BASIC_USERNAME = APP_CONFIG[:basis][:basic_username]
  BASIC_PASSWORD = APP_CONFIG[:basis][:basic_password]
  
  def self.base_url(scheme)
    if scheme == "https"
      URI::HTTPS.build({:host => HOST, :port => SSL_PORT}).to_s
    else
      URI::HTTP.build({:host => HOST, :port => PORT}).to_s
    end
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
      results = JSON.parse(res.body)
      if results.length == 0
        false
      else
        results.each do |result|
          role = result["role"]
          if role == "admin"
            return true
          else
            permissions = YAML::load(role["permissions"])
            if not permissions.nil? and permissions.include?(:view_statistics)
              return true
            end
          end
        end
      end
    end
    false
  end

  def self.get_members(identifier)
    users = []
    req = Net::HTTP::Get.new("/projects/#{identifier}/members")
    req.basic_auth BASIC_USERNAME, BASIC_PASSWORD
    res = Net::HTTP.start(HOST, PORT){|http|
      http.request(req)
    }
    pp res.body
    if res.is_a?(Net::HTTPSuccess)
      results = JSON.parse(res.body)
      if results.length == 0
        users
      else
        results.each do |result|
          users.append(result["login"])
        end
      end
    end
    users
  end

  def self.get_projects(user)
    projects = []
    req = Net::HTTP::Get.new("/users/#{user}/projects")
    req.basic_auth BASIC_USERNAME, BASIC_PASSWORD
    res = Net::HTTP.start(HOST, PORT){|http|
      http.request(req)
    }
    if res.is_a?(Net::HTTPSuccess)
      results = JSON.parse(res.body)
      projects = results["items"].map{|item| JSON.parse(item)}
    end
    projects
  end
end
