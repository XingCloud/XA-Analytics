class Report < ActiveRecord::Base

  belongs_to :project
  belongs_to :report_category
  has_many :report_tabs, :dependent => :destroy


  accepts_nested_attributes_for :report_tabs, :allow_destroy => true

  validates_presence_of :title

  scope :template, where(:project_id => nil)
  scope :uncategorized, where(:report_category_id => nil)

  def metrics_attributes
    attrs = {}
    report_tabs.each do |report_tab|
      attrs[report_tab.id] = report_tab.metrics_attributes
    end
    attrs.to_json
  end

  def short_attributes
    {:id => id, :title => title, :created_at => created_at, :report_category_id => report_category_id}
  end

  def js_attributes
    attributes.merge({:report_tabs_attributes => report_tabs.map(&:js_attributes)})
  end

  def clone_as_template

  end

end
