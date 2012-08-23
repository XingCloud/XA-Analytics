class Project < ActiveRecord::Base
  has_many :project_report_categories, :dependent => :destroy
  has_many :report_categories, :through => :project_report_categories
  has_many :project_reports, :dependent => :destroy
  has_many :reports, :through => :project_reports
  has_many :report_tabs, :dependent => :destroy
  has_many :metrics, :dependent => :destroy
  has_many :segments, :dependent => :destroy
  has_many :project_widgets, :dependent => :destroy
  has_many :widgets, :through => :project_widgets
  has_many :user_attributes, :dependent => :destroy

  validate :identifier, :presence => true, :uniqueness => true

  def self.fetch(identifier)
    project = Project.find_by_identifier(identifier) || Project.find_by_id(identifier) || Project.find_remote(identifier)
    if project.blank?
      raise ActiveRecord::RecordNotFound, "Project can not find #{identifier}"
    else
      project
    end
  end

  def self.find_remote(identifier)
    project = BasisService.find_project(identifier)
    if project.present?
      unless Project.exists?(:identifier => project["identifier"])
        Project.create(project.slice("identifier", "name"))
      end
    end

    Project.find_by_identifier(identifier)
  end

  def js_attributes
    attributes.merge({:segments => []})
  end

  def sync_user_attributes
    resp = AnalyticService.sync_user_attributes(self)
    if resp[:status] == 200
      UserAttribute.transaction do
        resp[:results].each do |result|
          if user_attributes.find_by_name(result["name"]).blank?
            user_attribute = user_attributes.build({:name => result["name"],
                                                    :nickname => result["nickname"].blank? ? nil: result["nickname"],
                                                    :atype => result["type"],
                                                    :project_id => id})
            if result["groupby_type"].present?
              user_attribute = result["groupby_type"]
            end
            raise ActiveRecord::Rollback unless user_attribute.save
          end
        end
        user_attributes.each do |user_attribute|
          if resp[:results].select{|result| result["name"] == user_attribute.name}.empty?
            raise ActiveRecord::Rollback unless user_attribute.destroy
          end
        end
      end
    end
  end

  def sync_segments
    filtered_segments = []
    segments.each do |segment|
      filtered_segments.append(segment) unless segment.sequence.blank?
    end
    AnalyticService.sync_segments("APPEND_OR_UPDATE", segments, self) unless filtered_segments.empty?
  end
end