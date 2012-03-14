class JsTemplatesController < ApplicationController
  
  ASSETS = YAML.load_file(Rails.root.join("config/assets.yml"))
  ASSET_ROOT            = File.expand_path((defined?(Rails) && Rails.root.to_s.length > 0) ? Rails.root : ENV['RAILS_ROOT'] || ".") unless defined?(ASSET_ROOT)
  
  def package
    parse_request
    
    raise "Can not find this package #{@package}" unless ASSETS.has_key?(@package)
    render :js => pack_templates
  end
  
  private
  
  def templates
    File.open(path, 'rb:UTF-8') {|f| f.read }
  end
  
  def glob_files(glob)
    absolute = Pathname.new(glob).absolute?
    paths = Dir[absolute ? glob : File.join(ASSET_ROOT, glob)].sort
    Rails.logger.warn("No assets match '#{glob}'") if paths.empty?
    paths
  end
  
=begin
  (function(){
  window.JST = window.JST || {};

  window.JST['_edit'] = Haml('sdfdf');
  window.JST['_show'] = Haml('.user\n  .abc\n    good\n    ');
  })();
=end
  
  def pack_templates
    text_parts = ["(function(){", "window.JST = window.JST || {};"]
    
    
    paths                  = ASSETS[@package].flatten.uniq.map {|glob| glob_files(glob) }.flatten.uniq
    
    text_parts += paths.map do |file|
      file =~ /\/views\/(.*?)\./
      name = $1
      contents = File.read(file).gsub(/\r?\n/, "\\n").gsub("'", '\\\\\'')
      
      "window.JST['#{name}'] = Haml('#{contents}');"
    end
    
    text_parts << "})();"
    text_parts.join("\n")
  end
  
  def jst_template?
    @extension =~ /jst\.haml/
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
