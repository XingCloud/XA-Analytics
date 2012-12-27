class Template::ProjectsController < Template::BaseController
  before_filter :filter_redirect

  def index
    @projects = Project.paginate(:page => params[:page])
  end

  def show
  end

  protected

  def filter_redirect
    if params[:format].blank?
      path = "/template/projects"
      index = request.path.index(path) + path.length + 1
      if index < request.path.length
        rpath = request.path[index..request.path.length - 1]
        redirect_to path + "##{rpath}"
      end
    end
  end

end