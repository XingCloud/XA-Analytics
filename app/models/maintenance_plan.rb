class MaintenancePlan < ActiveRecord::Base
  has_many :translations, :foreign_key => :rid, :conditions => ["translations.rtype = ?", "MaintenancePlan"], :dependent => :destroy

  validates_presence_of :begin_at, :end_at, :created_by
  validate do |maintenance_plan|
    maintenance_plan.end_at.to_i > maintenance_plan.begin_at.to_i
  end
  scope :current_plan, lambda{where("begin_at <= ? and end_at >= ? and keep_running = ?", Time.now, Time.now, false)}
  scope :current_notice, lambda{where("begin_at <= ? and end_at >= ? and keep_running = ?", Time.now, Time.now, true)}

  def localized_announcement
    translation = translations.find_by_rfield("announcement")
    if translation.present?
      translation.content
    else
      announcement
    end
  end
end
