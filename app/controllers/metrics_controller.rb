class MetricsController < ProjectBaseController
  before_filter :find_metric, :only => [:update]
  before_filter :filter_number_of_day, :only => [:create, :update]

  def show
    render :json => @metric.js_attributes
  end

  def create
    @metric = @project.metrics.build(params[:metric])
    if @metric.save
      render :json => @metric.js_attributes
    else
      render :json => @metric.js_attributes, :status => 400
    end
  end
  
  def update
    if @metric.update_attributes(params[:metric])
      render :json => @metric.js_attributes
    else
      render :json => @metric.js_attributes, :status => 400
    end
  end

  private
  
  def find_metric
    @metric = @project.metrics.find(params[:id])
  end

  def filter_number_of_day
    if params[:metric][:number_of_day].present? and params[:metric][:number_of_day_origin].blank?
      params[:metric][:number_of_day_origin] = 0
    elsif params[:metric][:number_of_day].blank? and params[:metric][:number_of_day_origin].present?
      params[:metric][:number_of_day] = 0
    end
  end
end