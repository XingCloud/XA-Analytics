class Project < ActiveRecord::Base
  has_many :report_categories, :dependent => :destroy
  has_many :reports, :dependent => :destroy
  has_many :report_tabs, :dependent => :destroy
  has_many :metrics, :dependent => :destroy
  has_many :segments,:dependent => :destroy
  
  validate :identifier, :presence => true, :uniqueness => true

  def self.fetch(identifier)
    project = Project.find_by_id(identifier) || Project.find_by_identifier(identifier) || Project.find_remote(identifier)
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
end