require 'set'

class Template::ReportsController < Template::BaseController
  before_filter :find_report, :only => [:show, :edit, :update, :destroy, :set_category]
  before_filter :admin_required, :only => [:create, :update, :destroy, :set_category]
  before_filter :json_header
  
  def index
    render :json => Report.template.all.map(&:js_attributes)
  end

  def show
    render :json => @report.js_attributes
  end

  def create
    @report = Report.new(params[:report])
    if @report.save
      render :json => @report, :status => 200
    else
      render :json => @report, :status => 500
    end
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
      render :json => @report, :status => 200
    else
      render :json => @report, :status => 500
    end
  end

  def destroy
    if @report.destroy
      render :json => @report, :status => 200
    else
      render :json => @report, :status => 500
    end
  end

  def set_category
    if (not params[:report_category_id].nil? and
        params[:report_category_id].present? and
        not ReportCategory.find_all_by_id(params[:report_category_id]).empty?)
      @report.report_category_id = params[:report_category_id]
      @report.save
    end

    render :json => @report, :status => 200

  end

  private

  def find_report
    @report = Report.find(params[:id])
  end

  def json_header
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
  end

end
