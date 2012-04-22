class ReportsController < ProjectBaseController
  before_filter :find_report, :only => [:show, :edit, :update, :destroy, :set_category]
  before_filter :json_header
  
  def index
    render :json => @project.reports.map(&:js_attributes)
  end

  def create
    @report = @project.reports.build(params[:report])
    if @report.save
      render :json => @report.js_attributes
    else
      render :json => @report.js_attributes, :status => 500
    end
  end

  def show
    render :json => @report.js_attributes
  end

  def render_segment
    render :partial=>'segments/segments'
  end
  
  def update
    @report.attributes = params[:report]
    report_tab_ids = params[:report][:report_tabs_attributes].map{|report_tab| report_tab[:id]}
    @report.report_tabs.each do |report_tab|
      if report_tab_ids.index(report_tab.id.to_s).nil?
        @report.report_tabs.destroy(report_tab.id)
      end
    end
    if @report.save
      render :json => @report.js_attributes
    else
      render :json => @report.js_attributes, :status => 500
    end
  end
  
  def destroy
    if @report.destroy
      render :json => @report.js_attributes
    else
      render :json => @report.js_attributes, :status => 500
    end
  end

  def set_category
    if (not params[:report_category_id].nil? and
        params[:report_category_id].present? and
        not @project.report_categories.find_all_by_id(params[:report_category_id]).empty?)
      @report.report_category_id = params[:report_category_id]
      @report.save
    end

    render :json => @report.js_attributes, :status => 200

  end

  private

  def find_report
     @report = @project.reports.find(params[:id])
  end

  def json_header
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
  end

end
