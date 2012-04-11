require 'casclient'
require 'casclient/frameworks/rails/filter'

cas_logger = CASClient::Logger.new(Rails.root.join('log/cas.log'))
cas_logger.level = Logger::DEBUG
 
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => APP_CONFIG[:cas_base_url],
  :enable_single_sign_out => true,
  :logger => cas_logger
)