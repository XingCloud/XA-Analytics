require "uri"
module MyCasClient
  
  def cas_for_authentication_url(controller)
    redirect_url = "http://p.xingcloud.com:11011/cas/login?service=#{URI.escape(controller.request.referer)}"

    if use_gatewaying?
      controller.session[:cas_sent_to_gateway] = true
      redirect_url << "&gateway=true"
    else
      controller.session[:cas_sent_to_gateway] = false
    end

    if controller.session[:previous_redirect_to_cas] &&
        controller.session[:previous_redirect_to_cas] > (Time.now - 1.second)
      log.warn("Previous redirect to the CAS server was less than a second ago. The client at #{controller.request.remote_ip.inspect} may be stuck in a redirection loop!")
      controller.session[:cas_validation_retry_count] ||= 0

      if controller.session[:cas_validation_retry_count] > 3
        log.error("Redirection loop intercepted. Client at #{controller.request.remote_ip.inspect} will be redirected back to login page and forced to renew authentication.")
        redirect_url += "&renew=1&redirection_loop_intercepted=1"
      end

      controller.session[:cas_validation_retry_count] += 1
    else
      controller.session[:cas_validation_retry_count] = 0
    end
    controller.session[:previous_redirect_to_cas] = Time.now

    log.debug("Redirecting to #{redirect_url.inspect}")
    redirect_url
  end
  
end

CASClient::Frameworks::Rails::Filter.send :extend, MyCasClient