class MaintenancePlan < ActiveRecord::Base
  validates_presence_of :begin_at, :end_at, :created_by
  validate do |maintenance_plan|
    maintenance_plan.end_at.to_i > maintenance_plan.begin_at.to_i
  end
  scope :current_plan, lambda{where("begin_at <= ? and end_at >= ?", Time.now, Time.now)}
end
