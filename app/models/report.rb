class Report < ActiveRecord::Base

  belongs_to :project
  belongs_to :report_categor
  has_many :report_tabs, :dependent => :destroy


  accepts_nested_attributes_for :report_tabs, :allow_destroy => true

  validates_presence_of :title
end
