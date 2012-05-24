class MetricsController < ProjectBaseController
  before_filter :find_metric, :only => [:update]

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
end