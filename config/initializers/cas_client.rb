require 'casclient'
require 'casclient/frameworks/rails/filter'

cas_logger = CASClient::Logger.new(Rails.root.join('log/cas.log'))
cas_logger.level = Logger::DEBUG
 
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "http://p.xingcloud.com:11011/cas/",
  :enable_single_sign_out => true,
  :logger => cas_logger
)