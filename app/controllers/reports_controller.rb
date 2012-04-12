class ReportsController < ProjectBaseController
  before_filter :find_report, :only => [:show, :edit, :update, :destroy, :set_category]
  
  def index
    @categories = @project.report_categories.order("position asc").all
    @reports = @project.reports.where(:report_category_id => nil).all
  end
  
  def new
    @report = @project.reports.build
    @report.report_tabs.build
    @report.report_tabs[0].project_id = @project.id
  end
  
  def create
    @report = @project.reports.build(params[:report])
    if @report.save
      redirect_to project_reports_path(@project)
    else
      render :new
    end
  end

  def edit

  end

  def show

  end
  
  def update
    @report.attributes = params[:report]
    report_tab_ids = params[:report][:report_tabs_attributes].map{|pair| pair[1][:id]}
    @report.report_tabs.each do |report_tab|
      if report_tab_ids.index(report_tab.id.to_s).nil?
        report_tab.destroy
      end
    end

    if @report.save
      redirect_to project_reports_path(@project)
    else
      render :edit
    end
  end
  
  def destroy
    @report.destroy
    redirect_to project_reports_path(@project)
  end

  def set_category
    if (not params[:report_category_id].nil? and
        params[:report_category_id].present? and
        not @project.report_categories.find_all_by_id(params[:report_category_id]).empty?)
      @report.report_category_id = params[:report_category_id]
      @report.save
      redirect_to project_reports_path(@project)
    else
      redirect_to project_reports_path(@project)
    end

  end
  
  private
  
  def find_report
    if @project.reports.find_all_by_id(params[:id]).empty?
      @report = Report.where(:project_id => nil).find(params[:id])
    else
      @report = @project.reports.find(params[:id])
    end
  end
  
end
