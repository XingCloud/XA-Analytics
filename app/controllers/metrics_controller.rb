class MetricsController < ProjectBaseController
  before_filter :find_metric, :only => [:edit, :update]
  before_filter :find_metric_with_template, :only => [:show]
  before_filter :json_header


  def show
    if @metric.present?
      render :json => @metric.js_attributes
    else
      @metric = Metric.template.find(params[:id])
      render :json => @metric.clone_as_template(@project.id).js_attributes
    end
  end

  def create
    @metric = @project.metrics.build(params[:metric])
    if @metric.save
      render :json => @metric.short_attributes
    else
      render :json => @metric.short_attributes, :status => 500
    end
  end
  
  def update
    @metric.attributes=(params[:metric])
    if @metric.save
      render :json => @metric.short_attributes
    else
      render :json => @metric.short_attributes, :status => 500
    end
  end

  private
  
  def find_metric
    @metric = @project.metrics.find(params[:id])
  end

  def find_metric_with_template
    @metric = @project.metrics.find_by_id(params[:id])
  end

  def json_header
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
  end
  
end