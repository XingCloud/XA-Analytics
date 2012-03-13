class Metric < ActiveRecord::Base
  belongs_to :project
  belongs_to :report
  belongs_to :combine, :class_name => :"Metric"
  
  OPERATIONS = ["count", "sum_val", "count_user", "average_val"]
  COMPARISION_OPERATORS = ["<", "<=", "=", ">", ">="]
  COMBINE_ACTIONS = ["addition", "division", "multiplication", "subduction"]
  
  accepts_nested_attributes_for :combine, :allow_destroy => true
  
  before_validation :correct_combine
  
  6.times do |i|
    define_method "event_key_#{i}" do
      self.event_key.to_s.split(".")[i]
    end
    
    define_method "event_key_#{i}=" do |arg|
      parts = self.event_key.to_s.split(".")
      parts[i] = arg
      self.event_key = parts.join(".")
    end
  end
  
  def short_attributes
    {:id => self.id, :project_id => self.project_id, :name => self.name}
  end
  
  protected
  
  def correct_combine
    if self.combine_action.blank?
      self.combine = nil
    end
  end
  
end