require "tabs_on_rails/bootstrap"
require "breadcrumb"

Dir.glob(Rails.root.join("app/models/reports/*.rb")) do |file|
  require_dependency file
end
