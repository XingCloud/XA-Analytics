class ProjectBaseController < ApplicationController
  before_filter :find_project
  before_filter :auth_project
  before_filter :filter_maintenance_plan
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

  def filter_maintenance_plan
    if MaintenancePlan.current_plan.first.present?
      @maintenance_plan = MaintenancePlan.current_plan.first
      render "maintenance_plans/show", :status => 503
      return
    end
  end

  def filter_v9
    @project = @project.filter_v9
  end

  def check_privilege
    user = User.find_by_name(session[:cas_user])
    if user
      project_user = ProjectUser.find_by_user_id(user.id)
      if project_user.role == "mgriant"
        render :json=>{:message=>"have no privilege"}, :status => 403
        return
      end
    end
  rescue
    render :json=>{:message=>""}, :status=>403
    return
  end
end
