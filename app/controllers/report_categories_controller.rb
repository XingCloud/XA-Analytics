class ReportCategoriesController < ProjectBaseController
  before_filter :find_category, :only => [:edit, :update, :destroy, :shift_up, :shift_down]
  before_filter :json_header

  def create
    last_category = @project.report_categories.order("position asc").last
    position = last_category.nil? ? 0 : last_category.position
    @category = @project.report_categories.build(params[:report_category].merge({:position => position+1}))
    if @category.save
      render :json => @category.js_attributes
    else
      render :json => @category.js_attributes, :status => 500
    end
  end

  def update
    if @category.update_attributes(params[:report_category])
      render :json => @category.js_attributes
    else
      render :json => @category.js_attributes, :status => 500
    end
  end

  def destroy
    @category.reports.each do |report|
      report.update_attribute(:report_category_id, nil)
    end
    if @category.destroy
      render :json => @category.js_attributes
    else
      render :json => @category.js_attributes, :status => 500
    end
  end

  def shift_up
    last_category = @project.report_categories.where("position < ?", @category.position).order("position asc").last
    if not last_category.nil?
      position = last_category.position
      last_category.update_attribute(:position, @category.position)
      if @category.update_attribute(:position, position)
        render :json => @project.report_categories.map(&:js_attributes)
      else
        render :json => @project.report_categories.map(&:js_attributes), :status => 500
      end
    else
      render :json => @project.report_categories.map(&:js_attributes)
    end

  end

  def shift_down
    first_category = @project.report_categories.where("position > ?", @category.position).order("position asc").first
    if not first_category.nil?
      position = first_category.position
      first_category.update_attribute(:position, @category.position)
      if @category.update_attribute(:position, position)
        render :json => @project.report_categories.map(&:js_attributes)
      else
        render :json => @project.report_categories.map(&:js_attributes), :status => 500
      end
    else
      render :json => @project.report_categories.map(&:js_attributes)
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
