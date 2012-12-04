class Service::BaseController < ActionController::Base
  http_basic_authenticate_with :name => APP_CONFIG[:service][:user], :password => APP_CONFIG[:service][:password]
end