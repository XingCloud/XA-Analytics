class ReportCategory < ActiveRecord::Base

  has_many :reports

  validates_presence_of :name

end
