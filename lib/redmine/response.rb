module Redmine
  class Response
    
    def success?
      @status == 0
    end
    
    def initialize(text)
      begin
        json = ActiveSupport::JSON.decode(text)
      rescue Exception => e
        
      end
      
      
    end
    
  end
end