# -*- coding: utf-8 -*-
class ProjectBaseController < ApplicationController
  before_filter :find_project
  before_filter :auth_project
  before_filter :filter_maintenance_plan
  before_filter :filter_v9
  before_filter :filter_redirect

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
      project_user = @project.project_users.find_by_user_id(user.id)
      if (not project_user.nil?) && project_user.role == "mgriant" # project_user为nil证明该用户为超管,之所以在user表里面,是因为曾经沦为某个project的member,参见fetch_project_members
        render :json=>{:message=>"have no privilege"}, :status => 403
        return
      end
    end
  rescue
    render :json=>{:message=>""}, :status=>403
    return
  end

  # consider we request url:http://a.xingcloud.com/projects/#{project_id}/project_users(or other resources) in the browser(not via ajax),
  # we need to redirect to http://a.xingcloud.com/projects/#{project_id}#project_users
  # refer route.rb from another redirect policy
  def filter_redirect
    if request.headers["Accept"].index("application/json").blank? and request.method == "GET"
      path = "/projects/#{params[:project_id].present? ? params[:project_id] : params[:id]}"
      index = request.path.index(path) + path.length + 1
      if index < request.path.length
        rpath = request.path[index..request.path.length - 1]
        redirect_to path + "##{rpath}"
      end
    end
  end
end
