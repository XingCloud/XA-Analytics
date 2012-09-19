class ProjectBaseController < ApplicationController
  before_filter :find_project
  before_filter :auth_project
  before_filter :filter_v9

  protected
  
  def find_project
    if params[:project_id].present?
      @project = Project.fetch(params[:project_id])
    else
      @project = Project.fetch(params[:id])
    end
  end

  def auth_project
    if not APP_CONFIG[:admin].include?(session[:cas_user])
      session[:projects_permissions] ||= {}
      if session[:projects_permissions][@project.identifier].blank?
        session[:projects_permissions][@project.identifier] = BasisService.auth_project(@project.identifier, session[:cas_user])
      end
      if not session[:projects_permissions][@project.identifier]
        render :file => "public/401.html", :status => :unauthorized
        return
      end
    end
  end

  def filter_v9
    @project = @project.filter_v9
  end
end