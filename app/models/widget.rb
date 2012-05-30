class Widget < ActiveRecord::Base
  belongs_to :metric
  belongs_to :report_tab
  has_many :widget_connectors, :dependent => :destroy
  has_many :projects, :through => :widget_connectors

  validates_presence_of :metric_id, :length, :title, :widget_type, :interval
  validates_numericality_of :length, :only_integer => true, :greater_than => 0

  scope :template, where(:project_id => nil)
  scope :custom, where(Widget.arel_table[:project_id].not_eq(nil))

  def js_attributes(project_id = nil)
    js_attributes = attributes
    if project_id.present?
      connector = widget_connectors.find_by_project_id(project_id)
      if connector.present?
        js_attributes[:widget_connector] = connector.attributes
      end
    end
    js_attributes
  end

end