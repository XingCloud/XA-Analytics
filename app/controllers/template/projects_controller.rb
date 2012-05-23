class Template::ProjectsController < Template::BaseController
  def index
    @projects = Project.paginate(:page => params[:page])
  end

end