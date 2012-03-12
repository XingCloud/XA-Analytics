module Redmine
  class Response
    
    attr_accessor :error, :data, :content
    
    def success?
      @result == true
    end
    
    def initialize(text)
      begin
        @content = text
        json = ActiveSupport::JSON.decode(text)
      rescue Exception => e
        @error = e.message
        return
      end
      
      @result = json["result"]
      @data = json["data"]
    end
    
  end
end