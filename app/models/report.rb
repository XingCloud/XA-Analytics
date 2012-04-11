class Report < ActiveRecord::Base

  belongs_to :project
  belongs_to :report_categor
  has_many :report_tabs, :dependent => :destroy


  accepts_nested_attributes_for :report_tabs, :allow_destroy => true

  validates_presence_of :title, :template

  COMMON_TEMPLATE = 1
  CUSTOM_TEMPLATE = 0

  scope :template, where(:template => COMMON_TEMPLATE)
end
