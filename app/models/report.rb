class Report < ActiveRecord::Base

  belongs_to :project
  belongs_to :report_category
  has_many :report_tabs, :dependent => :destroy


  accepts_nested_attributes_for :report_tabs, :allow_destroy => true

  validates_presence_of :title

  def metrics_attributes
    attrs = {}
    report_tabs.each do |report_tab|
      attrs[report_tab.id] = report_tab.metrics_attributes
    end
    attrs.to_json
  end

  def clone_as_template

  end

end
