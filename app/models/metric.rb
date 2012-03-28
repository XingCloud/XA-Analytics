class Metric < ActiveRecord::Base
  include Highchart::Metric
  
  belongs_to :project
  belongs_to :report
  belongs_to :combine, :class_name => :"Metric"
  
  OPERATIONS = ["count", "sum", "user_num"]
  COMPARISION_OPERATORS = ["gt", "lt", "ge", "le", "eq", "ne", "between"]
  COMBINE_ACTIONS = ["addition", "division", "multiplication", "subduction"]
  
  accepts_nested_attributes_for :combine, :allow_destroy => true
  
  before_validation :correct_combine
  validates_presence_of :name, :if => proc{|m| m.combine_id.blank? }
  validates_presence_of :comparison_operator, :if => proc{|m| m.comparison.present? }
  validates_presence_of :comparison, :if => proc {|m| m.comparison_operator.present? }
  validates_presence_of :condition
  
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
  
  def request_option
    options = {
      :event_key => self.event_key,
      :count_method => self.condition
    }
    
    options.merge!({
      :filter => {
        :comparison_operator => self.comparison_operator,
        :comparison_value => self.comparison
      }
    }) if self.comparison_operator.present?
    
    options
  end
  
  protected
  
  def correct_combine
    if self.combine_action.blank?
      self.combine = nil
    end
  end
  
end