class Project < ActiveRecord::Base
  has_many :reports
  validate :identifier, :presence => true, :uniqueness => true
  
end
