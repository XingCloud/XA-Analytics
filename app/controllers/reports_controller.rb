class ReportsController < ProjectBaseController
  before_filter :find_report_with_template, :only => [:show, :clone]
  before_filter :find_report, :only => [:edit, :update, :destroy, :set_category]
  before_filter :json_header

  def create
    @report = @project.reports.build(params[:report])
    if @report.save
      render :json => @report.js_attributes
    else
      render :json => @report.js_attributes, :status => 400
    end
  end

  def clone
    render :json => @report.clone_as_template(@project.id).js_attributes
  end

  def update
    if @report.update_attributes(params[:report])
      render :json => @report.js_attributes
    else
      render :json => @report.js_attributes, :status => 400
    end
  end
  
  def destroy
    if @report.destroy
      render :json => @report.js_attributes
    else
      render :json => @report.js_attributes, :status => 400
    end
  end

  def set_category
    if (not params[:report_category_id].nil? and
        params[:report_category_id].present? and
        not @project.report_categories.find_all_by_id(params[:report_category_id]).empty?)
      @report.report_category_id = params[:report_category_id]
      if @report.save
        render :json => @report.js_attributes, :status => 200
      else
        render :json => @report.js_attributes, :status => 400
      end
    end
  end

  private

  def find_report
    @report = @project.reports.find(params[:id])
  end

  def find_report_with_template
    @report = @project.reports.find_by_id(params[:id])
    if @report.nil?
      @report = Report.template.find(params[:id])
    end
  end

  def json_header
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
  end

end
