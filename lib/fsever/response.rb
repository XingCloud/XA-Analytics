module Fserver
  class Response
    attr_reader :state, :event, :error, :content, :data
    
    def success?
      @status == 0
    end
    
    def initialize(text)
      begin
        @content = text
        json = ActiveSupport::JSON.decode(text)
      rescue Exception => e
        @error = e.message
      end
      
      @status = json["status"]
      if @status == 0
        @data = json["val"]
      else
        @event = json["val"]["event"] rescue "[unknown]"
        @error = json["val"]["msg"] rescue "[unknown]"
      end
    end
    
  end
end
