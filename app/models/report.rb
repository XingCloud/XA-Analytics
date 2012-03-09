class Report < ActiveRecord::Base
  belongs_to :project
  has_many :metrics
  has_one :cycle
  
  TYPES = ["bar", "table", "line"]
  
end
