module Redmine
  module Base
    
    # Set ActiveMerchant gateways in test mode.
    #
    #   ActiveMerchant::Billing::Base.gateway_mode = :test
    mattr_accessor :gateway_mode

    # Set ActiveMerchant integrations in test mode.
    #
    #   ActiveMerchant::Billing::Base.integration_mode = :test
    mattr_accessor :integration_mode

    # Set both the mode of both the gateways and integrations
    # at once
    mattr_reader :mode

    def self.mode=(mode)
      @@mode = mode
      self.gateway_mode = mode
    end

    self.mode = :production

    # Return the matching gateway for the provider
    # * <tt>bogus</tt>: BogusGateway - Does nothing (for testing)
    # * <tt>moneris</tt>: MonerisGateway
    # * <tt>authorize_net</tt>: AuthorizeNetGateway
    # * <tt>trust_commerce</tt>: TrustCommerceGateway
    # 
    #   ActiveMerchant::Billing::Base.gateway('moneris').new
    def self.gateway(name)
      Redmine.const_get("#{name.to_s.downcase}_gateway".camelize)
    end
    
    # A check to see if we're in test mode
    def self.test?
      self.gateway_mode == :test
    end
  end
end