class JsTemplatesController < ApplicationController
  skip_before_filter :cas_filter
  before_filter :find_project, :only => [:xingcloud]
  
  ASSETS = YAML.load_file(Rails.root.join("config/assets.yml"))
  ASSET_ROOT            = File.expand_path((defined?(Rails) && Rails.root.to_s.length > 0) ? Rails.root : ENV['RAILS_ROOT'] || ".") unless defined?(ASSET_ROOT)
  
  def package
    parse_request
    
    raise "Can not find this package #{@package}" unless ASSETS.has_key?(@package)
    render :js => pack_templates
  end
  
  def xingcloud
    @cas_login_url = CASClient::Frameworks::Rails::Filter.cas_for_authentication_url(self)
    
    render :js => render_to_string("xingcloud", :layout=> false)
  end
  
  private
  
  def find_project
    @project = Project.find_by_identifier(params[:identifier]) || Project.first
  end
  
  def templates
    File.open(path, 'rb:UTF-8') {|f| f.read }
  end
  
  def glob_files(glob)
    absolute = Pathname.new(glob).absolute?
    paths = Dir[absolute ? glob : File.join(ASSET_ROOT, glob)].sort
    Rails.logger.warn("No assets match '#{glob}'") if paths.empty?
    paths
  end
  
  def pack_templates
    text_parts = ["(function(){", "window.JST = window.JST || {};"]
    
    
    paths                  = ASSETS[@package].flatten.uniq.map {|glob| glob_files(glob) }.flatten.uniq
    pp paths
    text_parts += paths.map do |file|
      file =~ /\/views\/(.*?)\./
      name = $1
      contents = File.read(file).gsub(/\r?\n/, "\\n").gsub("'", '\\\\\'')
      
      "window.JST['#{name}'] = Haml('#{contents}');"
    end
    
    text_parts << "})();"
    text_parts.join("\n")
  end
  
  def parse_request
    @package = params[:package]
    if params[:extension] =~ /^(.+)\.js$/
      @extension = $1
    else
      @extension = params[:extension]
    end
  end
end
