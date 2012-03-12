module MetricsHelper
  
  def combo_event_key(form_builder)
    fields = []
    parts = @metric.event_key.to_s.split(".")
    
    6.times do |i|
      fields << form_builder.select("event_key_#{i}", instance_variable_get("@event_key_#{i}") || [], {}, :html => {:style => "width: 100px", :class => "chzn-select"})
    end
    
    fields.join(".").html_safe
  end
end
