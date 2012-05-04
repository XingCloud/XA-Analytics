class Metric < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :report_tabs
  
  has_one :combine, :class_name => "Metric", :foreign_key => "combine_id"
  
  OPERATIONS = ["count", "sum", "user_num"]
  COMPARISION_OPERATORS = ["gt", "lt", "ge", "le", "eq", "ne"]
  COMBINE_ACTIONS = ["addition", "division", "multiplication", "subduction"]
  
  accepts_nested_attributes_for :combine, :allow_destroy => true
  
  before_validation :correct_combine
  
  validates_presence_of :name
  validates_presence_of :comparison_operator, :if => proc{|m| m.comparison.present? }
  validates_presence_of :comparison, :if => proc {|m| m.comparison_operator.present? }
  validates_presence_of :condition
  validates_numericality_of :number_of_day, :only_integer => true, :greater_than => 0, :if => proc{|m| m.number_of_day.present? }
  
  before_validation :correct_event_key
  
  has_paper_trail

  scope :template, where(:project_id => nil)
  
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

  def js_attributes
    attributes.merge({
      :combine_attributes => (combine.js_attributes unless combine.nil?),
      :event_key_0 => event_key_0,
      :event_key_1 => event_key_1,
      :event_key_2 => event_key_2,
      :event_key_3 => event_key_3,
      :event_key_4 => event_key_4,
      :event_key_5 => event_key_5
    })
  end

  def short_attributes
    {:id => self.id, :name => self.name, :project_id => project_id}
  end

  def template_attributes
    {:number_of_day => number_of_day,
     :name => name, :event_key => event_key,
     :condition => condition,
     :combine_action => combine_action,
     :comparison_operator => comparison_operator,
     :comparison => comparison}
  end

  def clone_as_template(project_id)
    new_metric = Metric.new(self.template_attributes)
    new_metric.project_id = project_id
    if not self.combine.nil?
      new_metric.combine = self.combine.clone_as_template(project_id)
    end
    new_metric
  end

  protected

  def correct_combine
    if self.combine_action.blank?
      self.combine = nil
    end
  end

end