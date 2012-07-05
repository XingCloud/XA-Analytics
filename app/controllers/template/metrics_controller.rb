class Template::MetricsController < Template::BaseController
  before_filter :find_metric, :only => [:show, :edit, :update]

  def show
    render :json => @metric.js_attributes
  end


  def create
    @metric = Metric.new(params[:metric])
    status = 200
    Metric.transaction do
      if @metric.save
        status = @metric.sync ? 200 : 500
      else
        status = 400
      end
      raise ActiveRecord::Rollback unless status == 200
    end
    render :json => @metric.js_attributes, :status => status
  end


  def update
    @metric.attributes = params[:metric]
    status = 200
    Metric.transaction do
      if @metric.save
        status = @metric.sync ? 200 : 500
      else
        status = 400
      end
      raise ActiveRecord::Rollback unless status == 200
    end
    render :json => @metric.js_attributes, :status => status
  end

  private

  def find_metric
    @metric = Metric.find(params[:id])
  end
end