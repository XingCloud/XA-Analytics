require "tabs_on_rails/bootstrap"
require "breadcrumb"
require "my_cas_client"

# Report 中已定义，重复定义出错 mismatch error.
#Dir.glob(Rails.root.join("app/models/reports/*.rb")) do |file|
#  require_dependency file
#end
