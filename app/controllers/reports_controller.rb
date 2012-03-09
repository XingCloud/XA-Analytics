class ReportsController < ApplicationController
  before_filter :find_project
  set_tab :add_report, :sub
  
  def new
    @report = @project.reports.build
  end

  private
  
  def find_project
    @project = Project.find(params[:project_id])
  end
  
end
