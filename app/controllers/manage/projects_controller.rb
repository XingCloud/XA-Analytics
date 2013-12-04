class Manage::ProjectsController < ApplicationController
  before_filter :authenticate_user!  #TODO wcl: move to ApplicationController
  before_filter :find_user
  layout "manage"

  def index
  end


private
   def find_user
     @login_user = current_user
   end
end