module ApplicationHelper
  include LayoutHelper
  
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
end
