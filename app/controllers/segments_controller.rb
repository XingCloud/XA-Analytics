class SegmentsController < ProjectBaseController

  before_filter :find_segment, :only => [:show, :update, :destroy]
  before_filter :json_header

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
    expression_ids = params[:segment][:expressions_attributes].map{|expression_attributes| expression_attributes[:id]}
    @segment.expressions.each do |expression|
      if expression_ids.index(expression.id.to_s).nil?
        @segment.expressions.destroy(expression.id)
      end
    end
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
    @segment = @project.segments.find(params[:id])
  end

  def json_header
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
  end

end