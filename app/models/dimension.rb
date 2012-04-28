class Dimension < ActiveRecord::Base
  belongs_to :report_tab
  validates_presence_of :name, :value, :dimension_type, :level
end
