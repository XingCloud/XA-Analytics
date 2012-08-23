class ReportsController < ProjectBaseController
  before_filter :find_report, :only => [:show, :edit, :update, :destroy, :set_category]

  def index
    check_reports
    reports = []
    @project.project_reports.visible.each do |project_report|
      reports.append(Report.find(project_report.report_id).merge_join_attributes(project_report))
    end
    render :json => reports.map(&:js_attributes)
  end

  def create
    @report = @project.reports.build(params[:report])
    Report.transaction do
      begin
        @report.save!
        @project.project_reports.create!({:report_id => @report.id})
        raise Exception unless @report.sync
        render :json => @report.js_attributes, :status => 200
      rescue ActiveRecord::RecordInvalid
        render :json => @report.js_attributes, :status => 400
        raise ActiveRecord::Rollback
      rescue Exception
        render :json => @report.js_attributes, :status => 500
        raise ActiveRecord::Rollback
      end
    end
  end

  def update
    Report.transaction do
      begin
        if @report.project_id.blank?
          new_report = update_as_new(params[:report], @report, @project)
          new_report.save!
          project_report = @project.project_reports.find_by_report_id(@report.id)
          project_report.update_attributes!({:display => false})
          ProjectReport.create!({:project_id => @project.id, :report_id => new_report.id})
          raise Exception unless new_report.sync
          render :json => new_report.js_attributes, :status => 200
        else
          @report.update_attributes!(params[:report])
          raise Exception unless @report.sync
          render :json => @report.js_attributes, :status => 200
        end
      rescue ActiveRecord::RecordInvalid
        render :json => @report.js_attributes, :status => 400
        raise ActiveRecord::Rollback
      rescue Exception
        render :json => @report.js_attributes, :status => 500
        raise ActiveRecord::Rollback
      end
    end
  end
  
  def destroy
    if @report.project_id.blank?
      project_report = @project.project_reports.find_by_report_id(@report.id)
      if project_report.update_attributes(:display => false)
        render :json => @report.js_attributes
      else
        render :json => @report.js_attributes, :status => 500
      end
    else
      if @report.sync("REMOVE") and @report.destroy
        render :json => @report.js_attributes
      else
        render :json => @report.js_attributes, :status => 400
      end
    end
  end

  def set_category
    if (not params[:report_category_id].nil? and
        params[:report_category_id].present? and
        not @project.report_categories.find_all_by_id(params[:report_category_id]).empty?)
      if @report.project_id.blank?
        project_report = @project.project_reports.find_by_report_id(@report.id)
        if project_report.update_attributes(:report_category_id => params[:report_category_id])
          render :json => @report.merge_join_attributes(project_report).js_attributes
        else
          render :json => @report.merge_join_attributes(project_report).js_attributes, :status => 400
        end
      else
        if @report.update_attributes(:report_category_id => params[:report_category_id])
          render :json => @report.js_attributes
        else
          render :json => @report.js_attributes, :status => 400
        end
      end
    end
  end

  private

  def find_report
    @report = @project.reports.find_by_id(params[:id])
    if @report.blank?
      @report = Report.template.find(params[:id])
    end
  end

  def check_reports
    report_ids = @project.report_ids
    has_new_report = false
    (Report.template | Report.where({:project_id => @project.id})).each do |report|
      if report_ids.index(report.id).blank?
        report_ids.append(report.id)
        has_new_report = true
      end
    end
    @project.update_attributes!({:report_ids => report_ids}) unless not has_new_report
  end

  def update_as_new(attributes, original, project)
    attributes[:report_tabs_attributes].each do |report_tab_attributes|
      report_tab_attributes[:id] = nil
      if report_tab_attributes[:dimensions_attributes].present?
        report_tab_attributes[:dimensions_attributes].each do |dimension_attributes|
          dimension_attributes[:id] = nil
        end
      end
    end
    attributes[:original_report_id] = original.id
    attributes[:project_id] = project.id
    Report.new(attributes)
  end
end
