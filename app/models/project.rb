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

  # add default menu
  def create_template_menus
    templates = Menu.all(:conditions => 'status = 0 and parent_id is null') # template menus
    if templates.blank?
      log.warn 'Plese configuration template menus.'
    else
      templates.each do |menu|
        parent = Menu.create(:name=>menu.name, :project_id => self.id, :desc => menu.desc)
        unless menu.children.blank?
          menu.children.each do |child|
            m = Menu.new
            m.name = child.name
            m.parent_id = parent.id
            m.project_id = self.id
            m.desc = child.desc
            m.reports << child.reports
            m.save
          end
        end
      end
    end
  end

end
