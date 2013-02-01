class MaintenancePlan < ActiveRecord::Base
  has_many :translations, :foreign_key => :rid, :conditions => ["translations.rtype = ?", "MaintenancePlan"], :dependent => :destroy

  validates_presence_of :begin_at, :end_at, :created_by
  validate do |maintenance_plan|
    maintenance_plan.end_at.to_i > maintenance_plan.begin_at.to_i
  end
  scope :current_plan, lambda{where("begin_at <= ? and end_at >= ? and keep_running = ?", Time.now, Time.now, false)}
  scope :current_notice, lambda{where("begin_at <= ? and end_at >= ? and keep_running = ?", Time.now, Time.now, true)}

  after_create :publish_notification

  def localized_announcement
    translation = translations.find_by_rfield("announcement")
    if translation.present?
      translation.content
    else
      announcement
    end
  end

  private

  def publish_notification
    if announcement.blank?
      text = "\n"+I18n.t(:maintenance_announcement_default)
    else
      text = "\n"+localized_announcement
    end
    text = "#{text} #{I18n.t(:maintenance_time)} #{begin_at.strftime("%H:%M %D")} #{I18n.t(:to)} #{end_at.strftime("%H:%M %D")}"
    PrivatePub.publish_to("/maintenance_plan", {
        :title => I18n.t(:maintenance),
        :text => text
    })
  end
end
