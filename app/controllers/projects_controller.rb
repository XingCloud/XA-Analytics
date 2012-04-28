class ProjectsController < ApplicationController
  before_filter :auth_project
  before_filter :find_project, :only => [:show, :members, :event_item, :dashboard]
  before_filter :html_header, :only => [:dashboard]

  def show
  end

  def dashboard
    @report = first_report(@project)
    if not @report.nil?
      @report_tab = @report.report_tabs.first
    end
    render :partial => "projects/dashboard"
  end
  
  def event_item
    @default_value = params[:condition][params[:target_row]] rescue nil
    json = AnalyticService.check_event_key(@project, params[:target_row], params[:condition])
    
    @items = json["data"]["items"]
    render :json => @items
  end

  def user_attributes
    json = AnalyticService.user_attribute(@project)
    @list = json["data"]
  end

  private

  def first_report(project)
    report = nil
    default_categories = ReportCategory.where({:project_id => nil}).order("position asc")
    default_reports = Report.where({:project_id => nil, :report_category_id => nil})
    categories = project.report_categories
    reports = project.reports.where(:report_category_id => nil)
    if not default_categories.empty?
      default_categories.all.each do |default_category|
        if not default_category.reports.empty?
          report = default_category.reports.first
          break
        end
      end
    elsif not default_reports.empty?
      report = default_reports.first
    elsif not categories.empty?
      categories.all.each do |category|
        if not category.reports.empty?
          report = category.reports.first
          break
        end
      end
    elsif not reports.empty?
      report = reports.first
    end
    report
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