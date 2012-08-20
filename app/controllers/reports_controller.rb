class ReportsController < ProjectBaseController
  before_filter :find_report_with_template, :only => [:show, :clone]
  before_filter :find_report, :only => [:edit, :update, :destroy, :set_category]

  def create
    @report = @project.reports.build(params[:report])
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

  def clone
    render :json => @report.clone_as_template(@project.id).js_attributes
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
    if @report.sync("REMOVE") and @report.destroy
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
end
