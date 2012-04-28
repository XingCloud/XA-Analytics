class ApplicationController < ActionController::Base
  helper_method :current_user
  before_filter :cas_filter
  #before_filter :debug_cas
  
  protected
  
  def current_user
    pp session[:cas_user]
    session[:cas_user]
  end

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