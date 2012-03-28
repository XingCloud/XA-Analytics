require 'will_paginate/view_helpers/action_view'

module WillPaginate
  module ActionView
    
    def will_paginate(collection = nil, options = {})
      options, collection = collection, nil if collection.is_a? Hash
      # Taken from original will_paginate code to handle if the helper is not passed a collection object.
      collection ||= infer_collection_from_controller 
      options[:renderer] ||= BootstrapLinkRenderer
      super.try :html_safe
    end

    class BootstrapLinkRenderer < LinkRenderer
      
      def to_html
        html = pagination.map do |item|
          item.is_a?(Fixnum) ?
            page_number(item) :
            send(item)
        end.join(@options[:link_separator])
        
        html += tag(:li, link(@template.page_entries_info(@collection), "#", :onclick => "return false;"), :class => "disabled next next_page")
        @options[:container] ? html_container(html) : html
      end
      
      protected
      
      def html_container(html)
        tag :div, tag(:ul, html), container_attributes
      end

      def page_number(page)
        tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
      end

      def gap
        tag :li, link(super, '#'), :class => 'disabled'
      end

      def previous_or_next_page(page, text, classname)
        tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
      end
    end
  end
end