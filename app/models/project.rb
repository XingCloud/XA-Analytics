class Project < ActiveRecord::Base
  
  validate :identifier, :presence => true, :uniqueness => true
  
end
