class Ad < ActiveRecord::Base
  attr_accessible :channel, :date, :fee, :project_id

  belongs_to :project
  validates_presence_of :date
  validates_presence_of :channel
  validates_presence_of :fee
  validates_uniqueness_of :channel, :scope=> [:project_id, :date]

  def js_attributes
    attributes
  end

end
