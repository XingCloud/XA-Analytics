class MaintenancePlansController < ApplicationController
  layout "template"
  def index
    @maintenance_plan = MaintenancePlan.current_plan.first
    render "maintenance_plans/show", :status => 503
  end

end