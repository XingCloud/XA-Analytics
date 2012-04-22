class Template::MetricsController < Admin::BaseController
  before_filter :find_metric, :only => [:edit, :update, :destroy]
  layout "dialog"

  def new
    @metric = Metric.new
    @metric.build_combine
    @tab_index = params[:tab_index]
  end

  def create
    @metric = Metric.new(params[:metric])
    if @metric.save
      @tab_index = params[:tab_index]
    else
      @metric.combine || @metric.build_combine
      render :new
    end
  end

  def edit
    @tab_index = params[:tab_index]
    unless @metric.combine
      @metric.build_combine
    end
  end

  def update
    @metric.attributes=(params[:metric])
    if @metric.save
      @tab_index = params[:tab_index]
    else
      render :edit
    end
  end

  def destroy
    @metric.destroy
    render :nothing => true
  end

  private

  def find_metric
    @metric = Metric.find(params[:id])
  end
end