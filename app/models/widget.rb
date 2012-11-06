class Widget < ActiveRecord::Base
  belongs_to :metric
  belongs_to :report_tab
  has_many :project_widgets, :dependent => :destroy
  has_many :projects, :through => :project_widgets
  has_many :translations, :foreign_key => :rid, :conditions => ["translations.rtype = ?", "Widget"], :dependent => :destroy

  validates_presence_of :metric_id, :length, :title, :widget_type, :interval
  validates_numericality_of :length, :only_integer => true, :greater_than => 0

  scope :template, where(:project_id => nil)
  scope :custom, where(Widget.arel_table[:project_id].not_eq(nil))

  def js_attributes(project_id = nil)
    js_attributes = attributes
    if project_id.present?
      connector = project_widgets.find_by_project_id(project_id)
      if connector.present?
        js_attributes[:project_widget] = connector.attributes
      end
    end
    js_attributes
  end

end