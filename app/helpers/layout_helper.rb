module LayoutHelper
  
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end 

  def show_title?
    @show_title
  end 

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end 

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def notice_message
    flash_messages = []

    flash.each do |type, message|
      type = :success if type == :notice
      text = content_tag(:div, link_to("x", "#", :class => "close", :"data-dismiss" => "alert") + message, :class => "alert alert-#{type}")
      flash_messages << text if message
    end

    flash_messages.join("\n").html_safe
  end
  
  def theads(*args)
    options = args.extract_options!
    content_tag(:thead) do
      content_tag(:tr, options[:tr_html]) do
        args.map do |arg|
          content_tag(:th, options[:td_html]) do
            if arg.is_a?(Symbol)
              I18n.t(arg)
            else
              arg.to_s
            end
          end
        end.join.html_safe
      end
    end
  end
  
  def tlist(collection, options = {}, &block)
    blank_message = options[:blank_message] || "Records Not Found."
    options[:tr_html] ||= {}
    
    if collection.blank?
      content_tag(:tr) do
        content_tag(:td, :colspan => options[:cols]) do
          content_tag(:div, blank_message,:class => "alert alert-info")
        end
      end
    else
      collection.map do |item|
        content_tag(:tr, options[:tr_html]) do
          yield item
        end
      end.join.html_safe
    end
  end
  
end