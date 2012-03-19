module LinkHelper
  
  def link_to_delete(url, options = {})
    link_to t(:delete), url, options.merge({:confirm => t(:confirm_msg), :method => :delete})
  end
  
  def button_to_delete(url, options = {})
    options[:class] = options[:class].to_a + ["btn btn-small btn-danger"]
    options[:confirm] ||= t(:confirm_msg)
    options[:method] = :delete
    
    link_to "<i class='icon-trash icon-white'></i> Delete".html_safe, url, options
  end
  
  def link_to_new(url, options = {})
    link_to t(:add_new), url, options
  end
  
  def link_to_edit(url, options = {})
    link_to t(:edit), url, options
  end
  
  def link_to_view(url, options = {})
    link_to t(:view), url, options
  end
  
  def link_to_cancel(url = nil)
    link_to t(:cancel), (url || {:action => :index}), {:class => "btn"}
  end
  
end