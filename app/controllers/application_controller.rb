class ApplicationController < ActionController::Base
  helper_method :current_user
  before_filter :cas_filter
  before_filter :set_locale
  #before_filter :debug_cas

  def logout
    reset_session
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

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

  def set_locale
    I18n.locale = "en"
    #I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
  
end