class AdsController < ProjectBaseController
  before_filter :find_ad, :only => [:show, :update, :destroy]
  after_filter :log_action, :only => [:create, :update, :destroy]

  def index
    render :json => @project.ads.map(&:js_attributes)
  end

  def show
    render :json => @ad.js_attributes
  end

  def create
    @ad = @project.ads.build(params[:ad])
    if @ad.save
      render :json => @ad.js_attributes
    else
      render :json => @ad.js_attributes, :status => 400
    end
  end

  def update
    @ad.attributes = params[:ad]
    if @ad.save
      render :json => @ad.js_attributes
    else
      render :json => @ad.js_attributes, :status => 400
    end
  end

  def destroy
    if @ad.destroy
      render :json => @ad.js_attributes
    else
      render :json => @ad.js_attributes, :status => 500
    end
  end

  private

  def find_ad
    @ad = @project.ads.find(params[:id])
  end


  def log_action
    Resque.enqueue(Workers::LogAction, @project.id,
                   "Ad", @ad.channel, action_name,
                   session[:cas_user], Time.now)
  end
end