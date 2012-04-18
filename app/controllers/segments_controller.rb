class SegmentsController < ApplicationController

  before_filter :find_project
  before_filter :html_header, :only => [:new, :edit,:destroy]
  @@IDX = 0

  def new
    @segment = Segment.new
    render :partial => 'common'
  end

  def create
    @segment = Segment.new(params[:segment].merge!(:project_id => @project.id))
    if @segment.create_segment(params[:expression_name], params[:expression_operator], params[:expression_value])
      render :json => @segment, :notice => t(:'segment.created.success')
    else
      render "new"
    end
  end

  def edit
    @segment = Segment.find_by_id(params[:id])
    render :partial => 'common'
  end

  def update
    @segment = Segment.find_by_id(params[:id])
    if @segment.update_segment(params[:segment], params[:expression_name], params[:expression_operator], params[:expression_value])
      render :json => @segment, :notice => t(:'segment.updated.success')
    else
      render :edit
    end

  end

  def template
    @idx = @@IDX += 1
    render :partial => 'shared/template', :locals => {:segment => nil, :idx => @idx}
  end


  def destroy
    @segment = @project.segments.find(params[:id])
    if @segment.destroy
      render :json => @segment, :status => 200 , :notice => t(:'segment.destroy.success')
    else
      render :json => @segment, :notice => t(:'segment.destroy.failed')
    end

  end

  private

  def find_project
    @project = Project.find_by_id(params[:project_id])
  end

  def html_header
    response.headers['Content-Type'] = 'text/html; charset=utf-8'
  end

end