class Template::SegmentsController < Template::BaseController
  before_filter :find_segment, :only => [:show, :update, :destroy]

  def show
    render :json => @segment.js_attributes
  end

  def create
    @segment = Segment.new(params[:segment])
    if @segment.save
      Resque.enqueue(Workers::SyncSegment, @segment.id, nil)
      render :json => @segment.js_attributes
    else
      render :json => @segment.js_attributes, :status => 400
    end
  end

  def update
    @segment.attributes = params[:segment]
    if @segment.save
      Resque.enqueue(Workers::SyncSegment, @segment.id, nil)
      render :json => @segment.js_attributes
    else
      render :json => @segment.js_attributes, :status => 400
    end
  end

  def destroy
    Resque.enqueue(Workers::SyncSegment, @segment.id, nil, "REMOVE")
    render :json => @segment.js_attributes
  end

  private

  def find_segment
    @segment = Segment.find(params[:id])
  end
end