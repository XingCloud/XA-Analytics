class MetricsController < ProjectBaseController
  before_filter :find_report
  before_filter :find_metric, :only => [:edit, :update, :destroy]
  layout "dialog"
  
  def new
    @metric = @report.metrics.build
    @metric.build_combine
    set_events
  end
  
  def create
    @metric = @report.metrics.build(params[:metric])
    if @metric.save
      flash.now[:notice] = t("metric.create.success")
    else
      set_events
      render :new
    end
  end
  
  def edit
    unless @metric.combine
      @metric.build_combine
    end
    set_events
  end
  
  def update
    @metric.attributes=(params[:metric])
    if @metric.save
      flash.now[:notice] = t("metric.update.success")
    else
      set_events
      render :edit
    end
  end
  
  def destroy
    @metric.destroy
    render :nothing => true
  end
  
  private
  
  def find_metric
    @metric = @report.metrics.find(params[:id])
  end
  
  def find_report
    @report = @project.reports.find(params[:report_id])
  end
  
  def set_events
    @events = @project.fetch_events
    split_event_keys(@events)
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