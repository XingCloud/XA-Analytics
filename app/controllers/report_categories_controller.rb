class ReportCategoriesController < ProjectBaseController
  before_filter :find_category, :only => [:edit, :update, :destroy, :shift_up, :shift_down]
  before_filter :json_header

  def create
    @category = @project.report_categories.build(params[:report_category])
    if @category.save
      render :json => @category.js_attributes
    else
      render :json => @category.js_attributes, :status => 400
    end
  end

  def update
    if @category.update_attributes(params[:report_category])
      render :json => @category.js_attributes
    else
      render :json => @category.js_attributes, :status => 400
    end
  end

  def destroy
    @category.reports.each do |report|
      report.update_attribute(:report_category_id, nil)
    end
    if @category.destroy
      render :json => @category.js_attributes
    else
      render :json => @category.js_attributes, :status => 400
    end
  end

  private

  def find_category
    @category = ReportCategory.find(params[:id])
  end

  def json_header
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
  end

end
