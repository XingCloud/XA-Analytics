class Project < ActiveRecord::Base
  has_many :reports
  has_many :metrics
  has_many :menus
  
  validate :identifier, :presence => true, :uniqueness => true
  
end