class UserAttributesController < ProjectBaseController
  before_filter :find_user_attribute, :only => [:destroy, :update]
  after_filter :log_action, :only => [:create, :destroy, :update]

  def index
    if @project.user_attributes.length == 0
      Resque.enqueue(Workers::SyncUserAttributes, @project.id)
    end
    render :json => @project.user_attributes.map(&:attributes)
  end

  def create
    params[:user_attribute][:gpattern] = nil unless params[:user_attribute][:gpattern].present?
    @user_attribute = @project.user_attributes.build(params[:user_attribute])

    AnalyticService.sync_user_attribute(@project, {:type => "SAVE", :params => [@user_attribute.serialize].to_json})
    if @user_attribute.save
      #Resque.enqueue(Workers::SyncUserAttributes, @project.id, "SAVE", @user_attribute.serialize)
      render :json => @user_attribute.attributes
    else
      render :json => @user_attribute.attributes, :status => 400
    end
  rescue Exception => e
    logger.error e.message
    logger.error e.backtrace.inspect
    render :json=>@user_attribute, :status => 500
  end

  def destroy
    #Resque.enqueue(Workers::SyncUserAttributes, @project.id, "REMOVE", @user_attribute.serialize)
    AnalyticService.sync_user_attribute(@project, {:type => "REMOVE", :params => [@user_attribute.serialize].to_json})
    if @user_attribute.destroy
      render :json => @user_attribute.attributes
    else
      render :json => @user_attribute.attributes, :status => 400
    end
  rescue Exception => e
    logger.error e.message
    logger.error e.backtrace.inspect
    render :json => @user_attribute, :status => 500
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

  def log_action
    Resque.enqueue(Workers::LogAction, @project.id,
                   "UserAttribute", @user_attribute.name, action_name,
                   session[:cas_user], Time.now)
  end
end