class Template::MaintenancePlansController < Template::BaseController
  before_filter :find_maintenance_plan, :only => [:update, :destroy]

  def index
    render :json => MaintenancePlan.all.map(&:attributes)
  end

  def create
    @maintenance_plan = MaintenancePlan.new({:created_by => session[:cas_user]}.merge(params[:maintenance_plan]))
    if @maintenance_plan.save
      render :json => @maintenance_plan.attributes
    else
      render :json => @maintenance_plan.attributes, :status => 400
    end
  end

  def update
    if @maintenance_plan.update_attributes(params[:maintenance_plan])
      render :json => @maintenance_plan.attributes
    else
      render :json => @maintenance_plan.attributes, :status => 400
    end
  end

  def destroy
    if @maintenance_plan.destroy
      render :json => @maintenance_plan.attributes
    else
      render :json => @maintenance_plan.attributes, :status => 500
    end
  end

  private

  def find_maintenance_plan
    @maintenance_plan = MaintenancePlan.find(params[:id])
  end
end