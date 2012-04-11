class MetricsController < ProjectBaseController
  before_filter :find_metric, :only => [:edit, :update, :destroy]
  layout "dialog"
  
  def new
    @metric = @project.metrics.build
    @metric.build_combine
    @tab_index = params[:tab_index]
  end
  
  def create
    @metric = @project.metrics.build(params[:metric])
    if @metric.save
      @tab_index = params[:tab_index]
    else
      @metric.combine || @metric.build_combine
      render :new
    end
  end
  
  def edit
    @tab_index = params[:tab_index]
    unless @metric.combine
      @metric.build_combine
    end
  end
  
  def update
    @metric.attributes=(params[:metric])
    if @metric.save
      @tab_index = params[:tab_index]
    else
      render :edit
    end
  end
  
  def destroy
    @metric.destroy
    render :nothing => true
  end
  
  private
  
  def find_metric
    @metric = @project.metrics.find(params[:id])
  end
  
end