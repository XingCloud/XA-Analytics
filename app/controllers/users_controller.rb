class UsersController < ApplicationController

  def sign_out
    reset_session
    CASClient::Frameworks::Rails::Filter.logout(self, root_url) and return
  end

end
