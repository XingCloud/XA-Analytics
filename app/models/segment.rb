class Segment < ActiveRecord::Base

  has_many :expressions, :dependent => :destroy
  belongs_to :project

  accepts_nested_attributes_for :expressions, :allow_destroy => true

  validates :name, :presence => true

  DEFAULT_USER_ATTRIBUTES = ["register_time", "last_login_time", "first_pay_time", "last_pay_time", "grade", "game_time", "pay_amount", "language", "platform"]

  scope :template, where(:project_id => nil)

  def to_hsh
    segments = {}
    self.expressions.each do |expression|
      segments.merge!(expression.to_hsh)
    end
    segments
  end

  def short_attributes
    {:id => id, :name => name}
  end

  def js_attributes
    attributes.merge({:expressions_attributes => expressions.map(&:attributes)})
  end

end
