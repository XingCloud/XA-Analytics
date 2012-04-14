class Admin::TemplateSegmentsController < Admin::BaseController

  set_tab :template_segments, :sidebar

  before_filter :find_segment, :only => [:edit, :destroy, :update]

  def index
    @segments = Segment.template.paginate(:page => params[:page])
  end

  def new
    @segment = Segment.new
  end

  def edit
    @segment = Segment.find_by_id(params[:id])
  end

  def create
    @segment = Segment.new(params[:segment])
    if @segment.create_segment(params[:expression_name], params[:expression_operator], params[:expression_value])
      redirect_to admin_template_segments_path, :notice => t(:'segment.create.success')
    else
      render :new
    end

  end

  def update
    if @segment.update_segment(params[:segment], params[:expression_name], params[:expression_operator], params[:expression_value])
      redirect_to admin_template_segments_path, :notice => t(:'segment.updated.success')
    else
      render :edit
    end

  end

  def destroy
    @segment.destroy
    redirect_to admin_template_segments_path, :notice => t(:'segment.destroy.success')
  end

  private

  def find_segment
    @segment = Segment.find_by_id(params[:id])
  end

end