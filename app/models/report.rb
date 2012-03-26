class Report < ActiveRecord::Base
  include Highchart::Report
  
  belongs_to :project
  has_many :metrics, :dependent => :destroy
  has_one :period, :dependent => :destroy
  has_many :menu_reports
  has_many :menus, :through => :menu_reports
  
  accepts_nested_attributes_for :metrics, :allow_destroy => true
  accepts_nested_attributes_for :period
  
  validates_presence_of :title, :type, :metric_ids, :period
  
  delegate :rate, :interval, :start_time, :end_time, :compare?, :to => :period
  delegate :identifier, :to => :project
  
  def do_public
    self.update_attributes(:public => true)
  end
  
  def self.type_name
    self.name.demodulize.underscore
  end
  
  def type_name
    self.class.type_name
  end
  
  def to_json
    super(:methods => [:type_name])
  end
end

Dir.glob(File.dirname(__FILE__) + "/reports/*.rb").each do |file|
  require_dependency file
end