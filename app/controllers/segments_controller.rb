class SegmentsController < ApplicationController

  before_filter :find_project

  def new
    @segment = Segment.new
    render :partial => 'form', :layout => 'popup'
  end

  def create
    @segment = Segment.new(params[:segment].merge!(:project_id => @project.id))
    @segment.create_segment(params[:expression_name], params[:expression_operator], params[:expression_value])
    if @segment.persisted?
      redirect_to project_segments_path, :notice => t("segments.create.success")
    else
      render "new"
    end
  end

  def edit
    @segment = Segment.find_by_id(params[:id])
    render :partial => 'form', :layout => 'popup'
  end

  def update
    @segment = Segment.find_by_id(params[:id])
    if @segment.update_segment(params[:segment], params[:expression_name], params[:expression_operator], params[:expression_value])
      redirect_to project_segments_path, :notice => t(:'segment.updated.success')
    else
      render :edit
    end

  end

  def template
    render :partial => 'shared/template', :locals => {:segment => nil}
  end


  def destroy
    @segment = @project.segments.find(params[:id])
    @segment.destroy
    redirect_to project_segments_path
  end

  private

  def find_project
    @project = Project.find_by_id(params[:project_id])
  end

end