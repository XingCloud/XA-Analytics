class Menu < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :project

  validate :name, :presence => true
end
