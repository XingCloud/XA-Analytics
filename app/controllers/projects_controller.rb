class ProjectsController < ApplicationController
  before_filter :find_project, :only => [:show, :members, :event_item]
  set_tab :project, :sidebar

  def show
    default_categories = ReportCategory.where({:project_id => nil}).order("position asc")
    default_reports = Report.where({:project_id => nil, :report_category_id => nil})
    categories = @project.report_categories
    reports = @project.reports.where(:report_category_id => nil)
    if not default_categories.empty?
      default_categories.all.each do |default_category|
        if not default_category.reports.empty?
          @report = default_category.reports.first
          break
        end
      end
    elsif not default_reports.empty?
      @report = default_reports.first
    elsif not categories.empty?
      categories.all.each do |category|
        if not category.reports.empty?
          @report = category.reports.first
          break
        end
      end
    elsif not reports.empty?
      @report = reports.first
    end

  end
  
  def event_item
    @default_value = params[:condition][params[:target_row]] rescue nil
    json = AnalyticService.check_event_key(@project, params[:target_row], params[:condition])
    
    @items = json["data"]["items"]
    render :layout => false
  end

  private

  def find_project
    @project = Project.fetch(params[:id])
  end
end