# coding: utf-8
module ReportsHelper
  
  def short_description(metric)
    text = metric_description(metric)
    
    if metric.combine.present?
      text << "<p> 与 </p>"
      
      text << metric_description(metric)
      text << "<p> 进行 #{I18n.t(metric.combine_action, :scope => [:constants, :metric])} 计算</p>"
    end
    
    content_tag(:div, metric.name, :class => "metric_label")
  end
  
  def metric_description(metric)
    text = "<p>指标 #{color_text(metric.event_key, 'green') },"
    if metric.comparison.present?
      text << "选中 值 #{color_text(metric.comparison_operator, 'red') } #{metric.comparison} 的范围</p>"
    end
    text << "对 #{color_text I18n.t(metric.condition, :scope => [:constants, :metric]), 'green'} 的统计结果"
  end
  
  def color_text(text, color)
    "<span style='color: #{color}'>#{text}</span>"
  end
end
