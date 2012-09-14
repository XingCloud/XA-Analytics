class Metric < ActiveRecord::Base
  belongs_to :project
  has_many :widgets, :dependent => :destroy
  has_many :report_tab_metrics, :dependent => :destroy
  has_many :report_tabs, :through => :report_tab_metrics
  
  has_one :combine, :class_name => "Metric", :foreign_key => "combine_id", :dependent => :destroy
  belongs_to :segment
  
  OPERATIONS = ["count", "sum", "user_num"]
  COMPARISION_OPERATORS = ["gt", "lt", "ge", "le", "eq", "ne"]
  COMBINE_ACTIONS = ["addition", "division", "multiplication", "subduction"]
  
  accepts_nested_attributes_for :combine, :allow_destroy => true
  
  before_validation :correct_combine
  
  validates_presence_of :name
  validates_presence_of :condition
  validates_numericality_of :number_of_day, :only_integer => true, :if => proc{|m| m.number_of_day.present? }
  validates_numericality_of :number_of_day_origin, :only_integer => true, :if => proc{|m| m.number_of_day_origin.present?}
  validates_numericality_of :scale, :if => proc{|m| m.scale.present?}
  
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
    attributes = self.attributes
    attributes.delete("event_key")
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
     :segment_id => segment_id}
  end

  def clone_as_template(project_id)
    new_metric = Metric.new(self.template_attributes)
    new_metric.project_id = project_id
    if not self.combine.nil?
      new_metric.combine = self.combine.clone_as_template(project_id)
    end
    new_metric
  end

  def is_duplicate(metric)
    (project_id == metric.project_id and
     ((combine_id == nil and metric.combine_id == nil) or
      (combine_id != nil and metric.combine_id != nil)) and
     number_of_day == metric.number_of_day and
     name == metric.name and
     event_key == metric.event_key and
     condition == metric.condition and
     combine_action == metric.combine_action and
     number_of_day_origin == metric.number_of_day_origin and
     segment_id == metric.segment_id and
     ((combine == nil and metric.combine == nil) or
      (combine != nil and metric.combine != nil and combine.is_duplicate(metric.combine))))
  end

  def sequence(type = nil, groupby_json = nil)
    options = {
        :interval => "DAY",
        :type => (type.present? ? type : "COMMON"),
    }
    if Project.find_by_id(project_id).present?
      options[:project_id] = Project.find_by_id(project_id).identifier
    end
    if combine.present?
      case combine_action.upcase
        when "ADDITION"
          options[:formula] = "x+y"
        when "DIVISION"
          options[:formula] = "x/y"
        when "MULTIPLICATION"
          options[:formula] = "x*y"
        when "SUBDUCTION"
          options[:formula] = "x-y"
      end
      options[:items] = [item_sequence("x", groupby_json),
                         combine.item_sequence("y", groupby_json)]
    else
      options[:formula] = "x"
      options[:items] = [item_sequence("x", groupby_json)]
    end
    options
  end

  protected

  def correct_combine
    if self.combine_action.blank?
      self.combine = nil
    end
  end

  def item_sequence(name, groupby_json)
    item = {
        :event_key => event_key,
        :name => name,
        :count_method => condition.upcase
    }
    if number_of_day.present?
      item[:number_of_day] = number_of_day
    end
    if number_of_day_origin.present?
      item[:number_of_day_origin] = number_of_day_origin
    end
    if segment_id.present?
      segment = Segment.find_by_id(segment_id)
      if segment.present? and segment.sequence.present?
        item[:segment] = segment.sequence.to_json
      end
    end
    if groupby_json.present?
      item[:groupby_json] = groupby_json
    end
    item
  end

end
