class Project < ActiveRecord::Base
  has_many :reports
  has_many :events
  
  validate :identifier, :presence => true, :uniqueness => true
  
end
