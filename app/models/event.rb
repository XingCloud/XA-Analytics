class Event < ActiveRecord::Base
  belongs_to :project
  
  validates_uniqueness_of :name, :scope => :project_id
  
end
