class ProjectBaseController < ApplicationController
  before_filter :find_project
  before_filter :auth_project
  
  protected
  
  def find_project
    @project = Project.fetch(params[:project_id])
  end

  def auth_project
    if not APP_CONFIG[:admin].include?(session[:cas_user])
      session[:projects_permissions] ||= {}
      if session[:projects_permissions][@project.identifier].blank?
        permissions = BasisService.auth_project(@project.identifier, session[:cas_user])
        if permissions.nil? or not permissions.include?(:view_statistics)
          session[:projects_permissions][@project.identifier] = false
        else
          session[:projects_permissions][@project.identifier] = true
        end
      end
      if not session[:projects_permissions][@project.identifier]
        render :file => "public/401.html", :status => :unauthorized
        return
      end
    end
  end

end