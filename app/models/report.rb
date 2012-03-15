class Report < ActiveRecord::Base
  belongs_to :project
  has_many :metrics, :dependent => :destroy
  has_one :cycle, :dependent => :destroy
  has_many :menu_reports
  has_many :menus,:through => :menu_reports
  
  def do_public
    self.update_attributes(:public => true)
  end
  
  
  def self.type_name
    self.name.demodulize.underscore
  end
  
  def type_name
    self.class.type_name
  end
  
end

Dir.glob(File.dirname(__FILE__) + "/reports/*.rb").each do |file|
  require_dependency file
end
