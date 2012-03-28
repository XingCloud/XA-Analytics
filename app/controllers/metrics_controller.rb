class MetricsController < ProjectBaseController
  before_filter :find_metric, :only => [:edit, :update, :destroy]
  layout "dialog"
  
  def new
    @metric = @project.metrics.build
    @metric.build_combine
  end
  
  def create
    @metric = @project.metrics.build(params[:metric])
    if @metric.save
      flash.now[:notice] = t("metric.create.success")
    else
      render :new
    end
  end
  
  def edit
    unless @metric.combine
      @metric.build_combine
    end
  end
  
  def update
    @metric.attributes=(params[:metric])
    if @metric.save
      flash.now[:notice] = t("metric.update.success")
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
  
  def split_event_keys(events)
    (0...6).each {|i|
      instance_variable_set "@event_key_#{i}", ["*"]
    }
    events.each do |event|
      event.to_s.split(".").each_with_index do |k, idx|
        var = instance_variable_get "@event_key_#{idx}"
        
        var << k unless var.include?(k)
      end
    end
  end
  
end