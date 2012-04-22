class Template::BaseController < ApplicationController
  layout "admin"
  before_filter :admin_required, :only => [:create, :update, :destroy]
  
  protected
  
  def admin_required
    unless APP_CONFIG[:admin].include?(session[:cas_user])
      render :file => "public/401.html", :status => :unauthorized
      return
    end
  end
end