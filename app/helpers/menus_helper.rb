module MenusHelper
  def nested_list(menus, &block)
    return "" if menus.blank?
    html = "<ul class='nav nav-list'>"
    menus.each do |menu|
      html << "<li id='menu_#{menu.id}' class='#{params[:id].to_i == menu.id ? 'active' : ''}'>"
      html << capture(menu,&block)
      html << nested_list(menu.children, &block)
      html << "</li>"
    end
    html << "</ul>"
    html.html_safe
  end
end
