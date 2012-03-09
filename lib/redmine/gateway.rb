require "net/http"
require "uri"

module Redmine
  class Gateway
    
    cattr_reader :implementations
    @@implementations = []
    
    def self.logger
      @logger ||= Logger.new("log/#{self.name}_gateway.log")
    end

    def self.inherited(subclass)
      super
      @@implementations << subclass
    end
    
    HOST = APP_CONFIG[:redmine]
    TOKEN = APP_CONFIG[:redmine_token]
    
    attr_reader :options
    
    def test?
      Base.gateway_mode == :test
    end
    
    protected
    
    def error(text)
      self.class.logger.error(text)
    end
    
    private # :nodoc: all

    def name 
      self.class.name.scan(/\:\:(\w+)Gateway/).flatten.first
    end
  end
end
