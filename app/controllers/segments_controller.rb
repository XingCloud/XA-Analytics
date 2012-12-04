class SegmentsController < ProjectBaseController
  before_filter :find_segment, :only => [:show, :update, :destroy]
  after_filter :log_action, :only => [:create, :update, :destroy]

  def index
    render :json => (Segment.template | @project.segments).map(&:js_attributes)
  end

  def show
    render :json => @segment.js_attributes
  end

  def create
    @segment = @project.segments.build(params[:segment])
    if @segment.save
      render :json => @segment.js_attributes
    else
      render :json => @segment.js_attributes, :status => 400
    end
  end


  def update
    @segment.attributes = params[:segment]
    if @segment.save
      render :json => @segment.js_attributes
    else
      render :json => @segment.js_attributes, :status => 400
    end
  end

  def destroy
    if @segment.destroy
      render :json => @segment.js_attributes
    else
      render :json => @segment.js_attributes, :status => 500
    end
  end

  private

  def find_segment
    @segment = @project.segments.find(params[:id])
  end

  def log_action
    Resque.enqueue(Workers::LogAction, @project.id,
                   "Segment", @segment.name, action_name,
                   session[:cas_user], Time.now)
  end
end