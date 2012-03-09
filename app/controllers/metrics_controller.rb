class MetricsController < ProjectBaseController
  
  def new
    @metric = Metric.new
    @events = @project.events.paginate(:page => params[:page])
    split_event_keys(@events)
    pp @event_key_1
    pp @event_key_2
    render :layout => "dialog"
  end
  
  
  private
  
  def split_event_keys(events)
    (0...6).each {|i|
      instance_variable_set "@event_key_#{i}", ["*"]
    }
    events.each do |event|
      event.name.to_s.split(".").each_with_index do |k, idx|
        var = instance_variable_get "@event_key_#{idx}"
        
        var << k unless var.include?(k)
      end
    end
  end
  
end
