class Project < ActiveRecord::Base
  has_many :reports
  has_many :metrics
  has_many :events
  has_many :menus
  
  validate :identifier, :presence => true, :uniqueness => true
  
  def fetch_events
    Rails.cache.fetch("Project.#{self.id}.events") do
      self.events.select("distinct name").map(&:name)
    end
  end
  
end
