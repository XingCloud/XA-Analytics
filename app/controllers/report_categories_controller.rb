class ReportCategoriesController < ProjectBaseController
  before_filter :find_category, :only => [:edit, :update, :destroy]

  def index
    check_report_categories
    report_categories = []
    @project.project_report_categories.visible.each do |project_report_category|
      category = ReportCategory.find(project_report_category.report_category_id)
      category.merge_join_attributes(project_report_category)
      report_categories.append(category)
    end
    render :json => report_categories.map(&:js_attributes)
  end

  def create
    @category = @project.report_categories.build(params[:report_category])
    if @category.save
      project_report_category = @project.project_report_categories.build({:report_category_id => @category.id})
      project_report_category.save
      render :json => @category.js_attributes
    else
      render :json => @category.js_attributes, :status => 400
    end
  end

  def update
    if @category.project_id.blank?
      project_report_category = @project.project_report_categories.find_by_report_category_id(@category.id)
      if project_report_category.update_attributes({:name => params[:report_category][:name],
                                                    :position => params[:report_category][:position]})
        render :json => @category.merge_join_attributes(project_report_category).js_attributes
      else
        render :json => @category.merge_join_attributes(project_report_category).js_attributes, :status => 400
      end
    else
      if @category.update_attributes(params[:report_category])
        render :json => @category.js_attributes
      else
        render :json => @category.js_attributes, :status => 400
      end
    end
  end

  def destroy
    if @category.project_id.blank?
      @category.reports.each do |report|
        project_report = @project.project_reports.find_by_report_id(report.id)
        project_report.update_attributes({:report_category_id => -1})
      end
      project_report_category = @project.project_report_categories.find_by_report_category_id(@category.id)
      if project_report_category.update_attributes({:display => false})
        render :json => @category.merge_join_attributes(project_report_category).js_attributes
      else
        render :json => @category.merge_join_attributes(project_report_category).js_attributes, :status => 500
      end
    else
      @category.reports.each do |report|
        report.update_attribute(:report_category_id, nil)
      end
      if @category.destroy
        render :json => @category.js_attributes
      else
        render :json => @category.js_attributes, :status => 500
      end
    end
  end

  private

  def find_category
    @category = @project.report_categories.find_by_id(params[:id])
    if @category.blank?
      @category = ReportCategory.template.find(params[:id])
    end
  end

  def check_report_categories
    report_category_ids = @project.report_category_ids
    has_new_report_category = false
    (ReportCategory.template | ReportCategory.where({:project_id => @project.id})).each do |report_category|
      if report_category_ids.index(report_category.id).blank?
        report_category_ids.append(report_category.id)
        has_new_report_category = true
      end
    end
    @project.update_attributes!({:report_category_ids => report_category_ids}) unless not has_new_report_category
  end
end
