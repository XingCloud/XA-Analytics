module Fserver
  class Gateway
    
    HOST = APP_CONFIG[:fserver]
    
    cattr_reader :implementations
    @@implementations = []
    
    def self.logger
      @logger ||= Logger.new("log/#{self.name}_gateway.log")
    end

    def self.inherited(subclass)
      super
      @@implementations << subclass
    end
    
    protected

    def error(text)
      self.class.logger.error(text)
    end
    
    def info(text)
      self.class.logger.info(text)
    end
    
  end
end