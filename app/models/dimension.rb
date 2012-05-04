class Dimension < ActiveRecord::Base
  belongs_to :report_tab
  validates_presence_of :name, :value, :dimension_type, :level

  def template_attributes
    {:name => name,
     :value => value,
     :dimension_type => dimension_type,
     :level => level}
  end

  def clone_as_template
    Dimension.new(self.template_attributes)
  end
end
