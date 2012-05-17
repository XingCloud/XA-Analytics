class Template::MetricsController < Template::BaseController
  before_filter :find_metric, :only => [:show, :edit, :update]
  before_filter :json_header

  def show
    render :json => @metric.js_attributes
  end


  def create
    @metric = Metric.new(params[:metric])
    if @metric.save
      render :json => @metric.short_attributes
    else
      render :json => @metric.short_attributes, :status => 400
    end
  end


  def update
    pp params[:metric]
    if @metric.update_attributes(params[:metric])
      render :json => @metric.short_attributes
    else
      render :json => @metric.short_attributes, :status => 400
    end
  end

  private

  def find_metric
    @metric = Metric.find(params[:id])
  end

  def json_header
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
  end

end