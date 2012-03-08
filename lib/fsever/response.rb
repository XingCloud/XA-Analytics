module Fserver
  class Response
    attr_reader :state, :err, :event, :message, :val
    
    def initialize(text)
      begin
        json = ActiveSupport::JSON.decode(text)
      rescue Exception => e
        @message = e.message
      end
      
      @status = json["status"]
      
      
    end
  end
end