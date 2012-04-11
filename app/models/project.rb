class Project < ActiveRecord::Base
  has_many :report_categories, :dependent => :destroy
  has_many :reports, :dependent => :destroy
  has_many :report_tabs, :dependent => :destroy
  has_many :metrics, :dependent => :destroy
  
  validate :identifier, :presence => true, :uniqueness => true
  
end