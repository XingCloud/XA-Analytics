class ProjectsController < ApplicationController
  before_filter :auth_project
  before_filter :find_project, :only => [:show, :members, :event_item, :chart, :dimensions]
  before_filter :html_header, :only => [:dashboard]

  def show
    @user_attributes = user_attributes(@project)
  end

  def event_item
    @default_value = params[:condition][params[:target_row]] rescue nil
    json = AnalyticService.check_event_key(@project, params[:target_row], params[:condition])
    
    @items = json["data"]["items"]
    render :json => @items
  end

  def chart
    render :json => {:id => params[:report_tab_id].to_i, :data => AnalyticService.request_data(@project, params)}
  end

  def dimensions
    render :json => {:id => params[:report_tab_id].to_i, :data => AnalyticService.request_dimensions(@project, params)}
  end

  private

  def user_attributes(project)
    resp = AnalyticService.user_attributes(project)
    if resp["result"]
      resp["data"]
    else
      []
    end
  rescue
    []
  end

  def html_header
    response.headers['Content-Type'] = 'text/html; charset=utf-8'
  end

  def find_project
    @project = Project.fetch(params[:id])
  end

  def auth_project
    if not APP_CONFIG[:admin].include?(session[:cas_user])
      @project = Project.fetch(params[:id])
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
end