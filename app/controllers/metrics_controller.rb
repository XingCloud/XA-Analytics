class MetricsController < ProjectBaseController
  before_filter :find_metric, :only => [:update]
  before_filter :filter_number_of_day, :only => [:create, :update]

  def index
    render :json => (Metric.template.where(:combine_id => nil) | @project.metrics.where(:combine_id => nil)).map(&:js_attributes)
  end

  def show
    render :json => @metric.js_attributes
  end

  def create
    @metric = @project.metrics.build(params[:metric])
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
    @metric = @project.metrics.find(params[:id])
  end

  def filter_number_of_day
    if params[:metric][:number_of_day].present? and params[:metric][:number_of_day_origin].blank?
      params[:metric][:number_of_day_origin] = 0
    elsif params[:metric][:number_of_day].blank? and params[:metric][:number_of_day_origin].present?
      params[:metric][:number_of_day] = 0
    end
  end
end