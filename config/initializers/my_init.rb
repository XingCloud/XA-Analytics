require "tabs_on_rails/bootstrap"
require "breadcrumb"
require "my_cas_client"

Dir.glob(Rails.root.join("app/models/reports/*.rb")) do |file|
  require_dependency file
end
