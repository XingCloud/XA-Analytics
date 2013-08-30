class Ad < ActiveRecord::Base
  attr_accessible :channel, :date, :fee, :project_id

  belongs_to :project
  validates_presence_of :date
  validates_presence_of :channel
  validates_presence_of :fee

  def js_attributes
    attributes
  end

end
