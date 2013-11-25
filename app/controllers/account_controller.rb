class AccountController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user

  def index
    @projects = []
    @user_projects = @user.project_users
    @user_projects.each do |user_project|
      @projects.append(Project.find(user_project.project_id))
    end

  end


private
   def find_user
     @user = current_user
   end
end