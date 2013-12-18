require "pp"
desc "migrate scale to support multiple scale"
task :migrate_scale => :environment do
  Metric.all.each do |metric|
    if metric.scale_startdate.nil?
      metric.scale_startdate="1970-01-01"
    end
    metric.scales=metric.scale_startdate+":"+metric.scale.to_s
    metric.save
  end
end