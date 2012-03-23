class ApplicationController < ActionController::Base
  protect_from_forgery
  include Bootstrap::Breadcrumb
  #load_and_authorize_resource
  
end
