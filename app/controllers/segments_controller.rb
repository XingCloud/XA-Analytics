class SegmentsController < ProjectBaseController
  before_filter :find_segment, :only => [:show, :update, :destroy]

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
    if @segment.update_attributes(params[:segment])
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
    @segment = @project.segments.find(params[:id])
  end
end