class AccountController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user

  def index
  end


private
   def find_user
     @login_user = current_user
   end
end