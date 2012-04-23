class Template::SegmentsController < Template::BaseController

  before_filter :find_segment, :only => [:edit, :destroy, :update]

  def index
    @segments = Segment.template.paginate(:page => params[:page])
    render :partial => "segments/list"
  end

  def new
    @segment = Segment.new
    render :partial => "segments/form"
  end

  def edit
    @segment = Segment.find_by_id(params[:id])
    render :partial => "segments/form"
  end

  def create
    @segment = Segment.new(params[:segment])
    if @segment.create_segment(params[:expression_name], params[:expression_operator], params[:expression_value])
      render :json => @segment,:notice => t(:'segment.created.success')
    else
      render :new
    end

  end

  def update
    if @segment.update_segment(params[:segment], params[:expression_name], params[:expression_operator], params[:expression_value])
      render :json => @segment,:notice => t(:'segment.updated.success')
    else
      render :edit
    end

  end

  def destroy
    if @segment.destroy
      render :json => @segment,:notice => t(:'segment.destroy.success')
    else
      render :json => @segment, :notice => t(:'segment.destroy.failed')
    end
  end

  private

  def find_segment
    @segment = Segment.find_by_id(params[:id])
  end

end