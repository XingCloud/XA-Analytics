module Bootstrap
  module Breadcrumb
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      receiver.send :helper, Helpers
      receiver.send :before_filter, :set_breadcrumbs
    end

    module ClassMethods
      protected
      
      def before_breadcrumb(options = {}, &block)
 #       @@breadcrumb_configs ||= []
#        @@breadcrumb_configs << [options, &block]
        
        class_eval <<-EOF
          before_filter :config_breadcrumb
        EOF
      end
    end

    module InstanceMethods
      protected
      
      def config_breadcrumb
        @@breadcrumb_configs.each do |config|
          if config.first[:only].present?
            allowed = config.first[:only].to_a.include?(self.action_name)
          elsif config.first[:except].present?
            allowed = config.first[:except].to_a.include?(self.action_name)
          else
            allowed = true
          end
                    
          if allowed
            self.instance_eval(config.last)
          end
        end
      end

      def set_breadcrumbs
        @breadcrumbs = ["<a href='/'>Home</a>".html_safe]
      end
      
      def drop_breadcrumb(title=nil, url=nil)
        title ||= @page_title
        url ||= url_for
        if title
          @breadcrumbs.push("<a href=\"#{url}\">#{title}</a>".html_safe)
        end
      end

      def drop_page_title(title)
        @page_title = title
        return @page_title
      end

      def no_breadcrumbs
        @breadcrumbs = []
      end
    end

    module Helpers

      def render_breadcrumb
        return "" if @breadcrumbs.size <= 0
        prefix = "".html_safe
        crumb = "".html_safe

        @breadcrumbs.each_with_index do |c, i|
          breadcrumb_class = []
          breadcrumb_class << "first" if i == 0
          breadcrumb_class << "last active" if i == (@breadcrumbs.length - 1)

          if i == (@breadcrumbs.length - 1)
            breadcrumb_content = c
          else
            breadcrumb_content = c + content_tag(:span, "/", :class => "divider")
          end

          crumb += content_tag(:li, breadcrumb_content ,:class => breadcrumb_class )
        end
        return prefix + content_tag(:ul, crumb, :class => "breadcrumb menu clearfix")
      end
    end
  end
  
end