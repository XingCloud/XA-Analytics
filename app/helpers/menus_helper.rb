module MenusHelper
  def nested_list(menus, &block)
    return "" if menus.blank?
    html = "<ul>"
    menus.each do |menu|
      html << "<li id='menu_#{menu.id}'>"
      html << capture(menu,&block)
      html << nested_list(menu.children, &block)
      html << "</li>"
    end
    html << "</ul>"
    html.html_safe
  end
end
