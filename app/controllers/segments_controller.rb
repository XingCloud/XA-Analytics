class SegmentsController < ProjectBaseController
  before_filter :find_segment, :only => [:show, :update, :destroy]

  def index
    render :json => (Segment.template | @project.segments).map(&:js_attributes)
  end

  def show
    render :json => @segment.js_attributes
  end

  def create
    @segment = @project.segments.build(params[:segment])
    if @segment.save
      if @segment.sync
        render :json => @segment.js_attributes
      else
        render :json => @segment.js_attributes, :status => 500
      end
    else
      render :json => @segment.js_attributes, :status => 400
    end
  end


  def update
    @segment.attributes = params[:segment]
    if @segment.save
      if @segment.sync
        render :json => @segment.js_attributes
      else
        render :json => @segment.js_attributes, :status => 500
      end
    else
      render :json => @segment.js_attributes, :status => 400
    end
  end

  def destroy
    if @segment.sync("REMOVE") and @segment.destroy
      render :json => @segment.js_attributes
    else
      render :json => @segment.js_attributes, :status => 500
    end
  end

  private

  def find_segment
    @segment = @project.segments.find(params[:id])
  end
end