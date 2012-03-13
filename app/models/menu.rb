class Menu < ActiveRecord::Base
  belongs_to :project
  
  acts_as_nested_set
  
  validate :name, :presence => true
end
