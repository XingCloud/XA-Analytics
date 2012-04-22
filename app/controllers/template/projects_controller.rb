class Template::ProjectsController < Admin::BaseController
  def index
    @projects = Project.paginate(:page => params[:page])
    render :layout => "admin"
  end

end