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
  
  def get_remote_events(page = 1)
    json = AnalyticService.events(self, page)
    
    if json["result"]
      if json["data"].present?
        pp json["data"]
        get_remote_events(page + 1)
      else
        #delete cache
        Rails.cache.delete("Project.#{self.id}.events")
      end
    else
      raise json["error"]
    end
  end

  def create_template_reports
    Report.find_all_by_template(1).each do |report|
      new_report = report.clone_as_template(self.id)
      if not new_report.save
        return false
      end
    end
    return true
  end
  
end
