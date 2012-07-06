class Template::ReportsController < Template::BaseController
  before_filter :find_report, :only => [:edit, :update, :destroy, :set_category]

  def index
    render :json => Report.template.all.map(&:js_attributes)
  end

  def create
    @report = Report.new(params[:report])
    status = 200
    Report.transaction do
      if @report.save
        status = @report.sync ? 200 : 500
      else
        status = 400
      end
      raise ActiveRecord::Rollback unless status == 200
    end
    render :json => @report.js_attributes, :status => status
  end

  def update
    @report.attributes = params[:report]
    status = 200
    Report.transaction do
      if @report.save
        status = @report.sync ? 200 : 500
      else
        status = 400
      end
      raise ActiveRecord::Rollback unless status == 200
    end
    render :json => @report.js_attributes, :status => status
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
        not ReportCategory.find_all_by_id(params[:report_category_id]).empty?)
      @report.report_category_id = params[:report_category_id]
      @report.save
    end

    render :json => @report.js_attributes, :status => 200

  end

  private

  def find_report
    @report = Report.find(params[:id])
  end
end
