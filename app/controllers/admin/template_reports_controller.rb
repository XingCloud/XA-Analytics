require 'set'

class Admin::TemplateReportsController < Admin::BaseController
  before_filter :find_report, :only => [:edit, :update, :destroy, :set_category]
  set_tab :template_reports, :sidebar
  
  def index
    @categories = ReportCategory.where(:project_id => nil).order("position asc").all
    @reports = Report.where({:project_id => nil, :report_category_id => nil}).all
  end

  def new
    @report = Report.new
    @report.report_tabs.build
  end

  def create
    @report = Report.new(params[:report])
    if @report.save
      redirect_to admin_template_reports_path()
    else
      render :new
    end
  end

  def edit

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
      redirect_to admin_template_reports_path()
    else
      render :edit
    end
  end

  def destroy
    @report.destroy
    redirect_to admin_template_reports_path()
  end

  def set_category
    if (not params[:report_category_id].nil? and
        params[:report_category_id].present? and
        not ReportCategory.find_all_by_id(params[:report_category_id]).empty?)
      @report.report_category_id = params[:report_category_id]
      @report.save
      redirect_to admin_template_reports_path()
    else
      redirect_to admin_template_reports_path()
    end

  end

  private

  def find_report
    @report = Report.find(params[:id])
  end
end
