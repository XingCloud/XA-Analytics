class AddScalesToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :scales, :text
  end
end


#Metric.all.each do |metric|
#  if metric.scale_startdate.nil?
#    metric.scale_startdate="1970-01-01"
#  end
#  metric.scales=metric.scale_startdate+":"+metric.scale.to_s
#  metric.save
#end
