class ProjectsController < ApplicationController
  before_filter :auth_project
  before_filter :find_project
  before_filter :filter_v9, :only => [:update_project_widgets]

  def show
  end

  def event_item
    @default_value = params[:condition][params[:target_row]] rescue nil
    json = AnalyticService.check_event_key(@project, params[:target_row], params[:condition])
    
    @items = json["data"]["items"]
    render :json => @items
  end

  def timelines
    resp = AnalyticService.request_data(@project, params[:request])
    render :json => {:id => params[:request_id].to_i, :data => resp[:results]}, :status => resp[:status]
  end

  def dimensions
    resp = AnalyticService.request_dimensions(@project, params[:request])
    render :json => {:id => params[:request_id].to_i, :data => resp[:results]}, :status => resp[:status]
  end

  def ups
    render :json => AnalyticService.ups(@project)
  end

  def update_project_widgets
    error = false
    ProjectWidget.transaction do
      begin
        JSON.parse(params[:project_widgets]).each do |project_widget_attributes|
          project_widget = @project.project_widgets.find(project_widget_attributes["id"])
          project_widget.update_attributes!(project_widget_attributes)
        end
      rescue
        error = true
        raise ActiveRecord::Rollback
      end
    end
    render :json => {}, :status => (error ? 400 : 200)
  end

  private

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

  def filter_v9
    @project = @project.filter_v9
  end
end