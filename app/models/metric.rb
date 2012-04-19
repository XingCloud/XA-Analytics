class Metric < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :report_tabs
  
  has_one :combine, :class_name => "Metric", :foreign_key => "combine_id"
  
  OPERATIONS = ["count", "sum", "user_num"]
  COMPARISION_OPERATORS = ["gt", "lt", "ge", "le", "eq", "ne"]
  COMBINE_ACTIONS = ["addition", "division", "multiplication", "subduction"]
  
  accepts_nested_attributes_for :combine, :allow_destroy => true
  
  before_validation :correct_combine
  
  validates_presence_of :name, :if => proc{|m| m.project_id.present? }
  validates_presence_of :comparison_operator, :if => proc{|m| m.comparison.present? }
  validates_presence_of :comparison, :if => proc {|m| m.comparison_operator.present? }
  validates_presence_of :condition
  validates_numericality_of :number_of_day, :only_integer => true, :greater_than => 0, :if => proc{|m| m.number_of_day.present? }
  
  before_validation :correct_event_key
  
  has_paper_trail
  
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
  
  def correct_event_key
    6.times do |i|
      if self.send("event_key_#{i}").blank? 
        self.send("event_key_#{i}=", "*")
      end
    end
  end

  def short_attributes
    {:id => self.id, :project_id => self.project_id, :name => self.name}
  end
  
  def template_attributes
    self.attributes.slice("event_key", "condition", "combine_action", "comparision_operator", "comparison", "name")
  end
  
  def clone_as_template(project_id)
    attrs = self.template_attributes
    attrs[:project_id] = project_id
    if not self.combine.nil?
      combine_attrs = self.combine.template_attributes
      attrs[:combine_attributes] = combine_attrs
    end
    Metric.new(attrs)
  end
  
  protected

  def correct_combine
    if self.combine_action.blank?
      self.combine = nil
    end
  end

end