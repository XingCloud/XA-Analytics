class ReportTabsController < ProjectBaseController
  before_filter :find_report_tab, :only => [:show, :update]
  before_filter :find_report_tab_with_template, :only => [:data, :dimensions]
  before_filter :json_header

  def show
    render :json => @report_tab.js_attributes
  end

  def update
    @report_tab.attributes = {
        :interval => params[:report_tab][:interval],
        :compare => params[:report_tab][:compare],
        :length => params[:report_tab][:length]
    }

    if @report_tab.save
      render :json => @report_tab.js_attributes
    else
      render :json => @report_tab.js_attributes, :status => 500
    end
  end

  def data
    service = AnalyticService.new()
    if check_data_params
      render :json => {:status => 200, :id => @report_tab.id, :data => service.request_data(@report_tab, params.merge({:identifier => @project.identifier}))}
    else
      render :json => {:status => 500, :id => @report_tab.id, :msg => "params not valid"}
    end
  end

  def dimensions
    service = AnalyticService.new()
    if check_dimensions_params
      render :json => {:status => 200, :id => @report_tab.id, :data => service.request_dimensions(@report_tab, params.merge({:identifier => @project.identifier}))}
    else
      render :json => {:status => 500, :id => @report_tab.id, :msg => "params not valid"}, :status => 500
    end
  end

  private

  def check_data_params
    return (params[:end_time].present? and
            params[:compare_end_time].present? and
            params[:compare].present? and
            params[:length].present? and
            params[:interval].present?)
  end

  def check_dimensions_params
    return (params[:end_time].present? and
            params[:length].present? and
            params[:dimension].present? and
            params[:interval].present?)
  end

  def find_report_tab
    @report = @project.reports.find(params[:report_id])
    @report_tab = @report.report_tabs.find(params[:id])
  end

  def find_report_tab_with_template
    @report = @project.reports.find_by_id(params[:report_id])
    if @report.blank?
      @report = Report.template.find(params[:report_id])
    end
    @report_tab = @report.report_tabs.find(params[:id])
  end

  def json_header
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
  end
end
