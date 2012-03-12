class Report < ActiveRecord::Base
  belongs_to :project
  has_many :metrics, :dependent => :destroy
  has_one :cycle, :dependent => :destroy
  
  def do_public
    self.update_attributes(:public => true)
  end
  
end


require_dependency "reports/line"
require_dependency "reports/bar"
require_dependency "reports/table"