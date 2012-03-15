module ApplicationHelper
  include LayoutHelper
  include LinkHelper
  
  def translate_collection(array, options = {})
    scope = if options[:scope].is_a?(Array)
      options[:scope].unshift(:constants)
    else
      [:constants, options[:scope]]
    end
    
    array.map{|item|
      [I18n.t(item, :scope => scope), item]
    }
  end
  
  def include_js_template(*args)
    filenames = args.map do |arg|
      "/js_templates/#{arg}.jst.haml"
    end
    
    #content_for(:head) { 
      javascript_include_tag(*filenames)
    #}
  end
  
end
