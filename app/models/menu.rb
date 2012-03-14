class Menu < ActiveRecord::Base
  acts_as_nested_set :scope => :project_id
  belongs_to :project
  has_many :reports
  include MenuSortable
  
  validate :name, :presence => true
  
end