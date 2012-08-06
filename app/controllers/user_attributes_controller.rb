class UserAttributesController < ProjectBaseController
  before_filter :find_user_attribute, :only => [:destroy, :update]

  def index
    render :json => @project.user_attributes.map(&:attributes)
  end

  def create
    params[:user_attribute][:gpattern] = nil unless params[:user_attribute][:gpattern].present?
    @user_attribute = @project.user_attributes.build(params[:user_attribute])
    if sync(@project, "SAVE", @user_attribute)
      success = @user_attribute.save
      render :json => @user_attribute.attributes, :status => success ? 200 : 400
    else
      render :json => @user_attribute.attributes, :status => 500
    end
  end

  def destroy
    error = true
    if sync(@project, "REMOVE", @user_attribute)
      error = !@user_attribute.destroy
    end
    render :json => @user_attribute.attributes, :status => error ? 500 : 200
  end

  def update
    gpattern = params[:user_attribute][:gpattern].blank? ? nil : params[:user_attribute][:gpattern]
    error = !@user_attribute.update_attributes({:nickname => params[:user_attribute][:nickname],
                                                :gpattern => gpattern})
    render :json => @user_attribute.attributes, :status => error ? 400 : 200
  end

  private

  def find_user_attribute
    @user_attribute = @project.user_attributes.find(params[:id])
  end

  def sync(project, action, user_attribute)
    resp = AnalyticService.sync_user_attribute(project, {:type => action, :params => [user_attribute.serialize].to_json})
    resp[:status] == 200
  end
end