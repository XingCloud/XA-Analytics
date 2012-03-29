# -*- coding: utf-8 -*-

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

metric = Metric.new({:name => "登陆人数",
                     :event_key => "visit.*.*.*.*.*",
                     :condition => "user_num",
                     :combine_action => "",
                     :comparison_operator => "",
                     :comparison => "",
                     :combine_id => nil})
if metric.save
  report = Report::LineReport.new({:title => "登陆人数",
                           :metric_ids => [metric.id],
                           :description => "",
                           :period_attributes => {:rule => "last_day", :rate => "min5", :compare_number => "0"},
                           :template => 1})
  if report.save
    puts "successfully create report for 登陆人数"
  else
    puts "failed to create report for 登陆人数"
  end
else
  puts "failed to create report for 登陆人数"
end

metric = Metric.new({:name => "登陆次数",
                     :event_key => "visit.*.*.*.*.*",
                     :condition => "count",
                     :combine_action => "",
                     :comparison_operator => "",
                     :comparison => "",
                     :combine_id => nil})
if metric.save
  report = Report::LineReport.new({:title => "登陆次数",
                          :metric_ids => [metric.id],
                          :description => "",
                          :period_attributes => {:rule => "last_day", :rate => "min5", :compare_number => "0"},
                          :template => 1})
  if report.save
    puts "successfully create report for 登陆次数"
  else
    puts "failed to create report for 登陆次数"
  end
else
  puts "failed to create report for 登陆次数"
end

metric = Metric.new({:name => "支付用户数",
                     :event_key => "pay.*.*.*.*.*",
                     :condition => "user_num",
                     :combine_action => "",
                     :comparison_operator => "",
                     :comparison => "",
                     :combine_id => nil})
if metric.save
  report = Report::LineReport.new({:title => "支付用户数",
                           :metric_ids => [metric.id],
                           :description => "",
                           :period_attributes => {:rule => "last_day", :rate => "min5", :compare_number => "0"},
                           :template => 1})
  if report.save
    puts "successfully create report for 支付用户数"
  else
    puts "failed to create report for 支付用户数"
  end
else
  puts "failed to create report for 支付用户数"
end

metric = Metric.new({:name => "支付额",
                     :event_key => "pay.*.*.*.*.*",
                     :condition => "sum",
                     :combine_action => "",
                     :comparison_operator => "",
                     :comparison => "",
                     :combine_id => nil})
if metric.save
  report = Report::LineReport.new({:title => "支付额",
                           :metric_ids => [metric.id],
                           :description => "",
                           :period_attributes => {:rule => "last_day", :rate => "min5", :compare_number => "0"},
                           :template => 1})
  if report.save
    puts "successfully create report for 支付额"
  else
    puts "failed to create report for 支付额"
  end
else
  puts "failed to create report for 支付额"
end

metric = Metric.new({:name => "支付次数",
                     :event_key => "pay.*.*.*.*.*",
                     :condition => "count",
                     :combine_action => "",
                     :comparison_operator => "",
                     :comparison => "",
                     :combine_id => nil})
if metric.save
  report = Report::LineReport.new({:title => "支付次数",
                           :metric_ids => [metric.id],
                           :description => "",
                           :period_attributes => {:rule => "last_day", :rate => "min5", :compare_number => "0"},
                           :template => 1})
  if report.save
    puts "successfully create report for 支付次数"
  else
    puts "failed to create report for 支付次数"
  end
else
  puts "failed to create report for 支付次数"
end

metric = Metric.new({:name => "ARPU值",
                     :event_key => "pay.*.*.*.*.*",
                     :condition => "sum",
                     :combine_action => "division",
                     :comparison_operator => "",
                     :comparison => "",
                     :combine_attributes => {:event_key => "pay.*.*.*.*.*",
                                             :condition => "user_num",
                                             :comparison_operator => "",
                                             :comparison => ""}})
if metric.save
  report = Report::LineReport.new({:title => "ARPU值",
                           :metric_ids => [metric.id],
                           :description => "",
                           :period_attributes => {:rule => "last_day", :rate => "min5", :compare_number => "0"},
                           :template => 1})
  if report.save
    puts "successfully create report for ARPU值"
  else
    puts "failed to create report for ARPU值"
  end
else
  puts "failed to create report for ARPU值"
end

metric = Metric.new({:name => "付费率",
                     :event_key => "pay.*.*.*.*.*",
                     :condition => "user_num",
                     :combine_action => "division",
                     :comparison_operator => "",
                     :comparison => "",
                     :combine_attributes => {:event_key => "visit.*.*.*.*.*",
                                             :condition => "user_num",
                                             :comparison_operator => "",
                                             :comparison => ""}})
if metric.save
  report = Report::LineReport.new({:title => "付费率",
                           :metric_ids => [metric.id],
                           :description => "",
                           :period_attributes => {:rule => "last_day", :rate => "min5", :compare_number => "0"},
                           :template => 1})
  if report.save
    puts "successfully create report for 付费率"
  else
    puts "failed to create report for 付费率"
  end
else
  puts "failed to create report for 付费率"
end