class ApplicationController < ActionController::Base
  helper_method :current_user
  before_filter :cas_filter
  before_filter :check_browser, :except => :logout
  before_filter :set_locale, :except => :logout
  #before_filter :debug_cas

  def logout
    reset_session
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

  def redirect
    if not APP_CONFIG[:admin].include?(session[:cas_user])
      projects = BasisService.get_projects(session[:cas_user])
      if projects.length > 0
        redirect_to project_path(projects[0]["identifier"])
      else
        render "misc/no_projects"
        return
      end
    else
      redirect_to template_projects_url()
    end
  end

  def projects_summary
    projects = BasisService.get_projects(session[:cas_user])
    render :json => projects.map{|project| {:identifier => project["identifier"], :name => project["name"]}}
  end

  def projects_details
    projects = BasisService.get_projects(session[:cas_user])
    user = User.find_by_name(session[:cas_user])
    render :json => projects.map{|project|
      project = Project.fetch(project["identifier"])
      project.attributes
    }
  end

  def home
    render "projects/index"
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
    if request.user_preferred_languages.present? and request.user_preferred_languages.first.present?
      I18n.locale = request.user_preferred_languages.first[0..1]
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
  
end