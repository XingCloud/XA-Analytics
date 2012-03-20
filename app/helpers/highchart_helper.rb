module HighchartHelper
  
  def ajax_load_report_data(report)
    js = []
    report.metrics.each_with_index do |metric, idx|
      js << <<-EOF
        render_metric('#{request_data_project_report_path(report.project, report, :metric_id => metric.id)}', #{idx})
      EOF
    end
    
    js.join("\n")
  end
  
end