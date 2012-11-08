class ApplicationController < ActionController::Base
  helper_method :current_user
  before_filter :check_browser
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
    browser_locale = request.user_preferred_languages.first[0..1]
    if UserPreference.where({:user => session[:cas_user], :key => "language"}).first.present?
      user_locale = UserPreference.where({:user => session[:cas_user], :key => "language"}).first.value
    end
    I18n.locale = user_locale || browser_locale
    pp request.user_preferred_languages.first
  end

  def check_browser
    browser = Browser.new(:ua => request.env['HTTP_USER_AGENT'], :accept_language => request.env['HTTP_ACCEPT_LANGUAGE'])
    if browser.ie? and browser.version.to_i < 8
      if params[:force_ie] == "1" or session[:force_ie]
        session[:force_ie] = true
      else
        render "misc/no_ie"
        return
      end
    end
  end
  
end