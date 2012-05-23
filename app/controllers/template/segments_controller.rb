class Template::SegmentsController < Template::BaseController

  before_filter :find_segment, :only => [:show, :update, :destroy]
  before_filter :json_header

  def show
    render :json => @segment.js_attributes
  end

  def create
    @segment = Segment.new(params[:segment])
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
      render :json => @segment.js_attributes, :status => 400
    end
  end

  private

  def find_segment
    @segment = Segment.find(params[:id])
  end

  def json_header
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
  end
end