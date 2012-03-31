class ApplicationController < ActionController::Base
  include Bootstrap::Breadcrumb
  
  before_filter :cas_filter
  #before_filter :debug_cas
  
  protected
  
  def cas_filter
    CASClient::Frameworks::Rails::Filter.filter(self)
  end
  
  def debug_cas
    pp session
  end
  
  def user_for_paper_trail
    session[:cas_user]
  end
  
end