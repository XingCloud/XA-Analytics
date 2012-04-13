class ReportsController < ProjectBaseController
  before_filter :find_report, :only => [:show, :edit, :update, :destroy, :set_category]
  before_filter :html_header, :only => [:index, :new, :edit]
  before_filter :json_header, :only => [:create, :update, :destroy, :set_category]
  
  def index
    @categories = @project.report_categories.order("position asc").all
    @reports = @project.reports.where(:report_category_id => nil).all
    render :partial => "reports/list", :status => 200
  end
  
  def new
    @report = @project.reports.build
    @report.report_tabs.build
    @report.report_tabs[0].project_id = @project.id
    render :partial => "reports/form", :status => 200
  end
  
  def create
    @report = @project.reports.build(params[:report])
    if @report.save
      render :json => @report, :status => 200
    else
      render :json => @report, :status => 500
    end
  end

  def edit
    render :partial => "reports/form", :status => 200
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
        not @project.report_categories.find_all_by_id(params[:report_category_id]).empty?)
      @report.report_category_id = params[:report_category_id]
      @report.save
    end

    render :json => @report, :status => 200

  end
  
  private
  
  def find_report
    if @project.reports.find_all_by_id(params[:id]).empty?
      @report = Report.where(:project_id => nil).find(params[:id])
    else
      @report = @project.reports.find(params[:id])
    end
  end

  def html_header
    response.headers['Content-Type'] = 'text/html; charset=utf-8'
  end

  def json_header
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
  end
  
end
