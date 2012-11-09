class Dimension < ActiveRecord::Base
  belongs_to :report_tab
  validates_presence_of :value, :dimension_type, :level

  def template_attributes
    {:value => value,
     :dimension_type => dimension_type,
     :level => level}
  end

  def clone_as_template
    Dimension.new(self.template_attributes)
  end

  def to_hsh(filter_value)
    if value_type == 'int'
      {value => filter_value.to_i}
    else
      {value => filter_value}
    end
  end
end
