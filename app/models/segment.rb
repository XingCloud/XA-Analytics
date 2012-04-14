class Segment < ActiveRecord::Base

  has_many :expressions, :dependent => :destroy
  belongs_to :project

  DEFAULT_SEGMENT = 0 # 通用
  CUSTOM_SEGMENT = 1 #自定义
  validates :name, :presence => true

  DEFAULT_USER_ATTRIBUTES = ["register_time", "last_login_time", "first_pay_time", "last_pay_time", "grade", "game_time", "pay_amount", "language", "platform"]

  scope :template, where(:status => DEFAULT_SEGMENT)

  scope :customs, lambda { |project| where(:status => CUSTOM_SEGMENT, :project_id => project.id) }

  def create_segment(names, operators, values)
    self.transaction do
      self.save
      names.each_with_index do |item, index|
        self.expressions.create(:name => names[index], :operator => operators[index], :value => values[index])
      end
    end
    self
  end

  #
  def update_segment(segments, names, operators, values)
    self.transaction do
      self.update_attributes(segments)
      self.expressions.destroy_all
      names.each_with_index do |item, index|
        self.expressions.create(:name => names[index], :operator => operators[index], :value => values[index])
      end
    end
  end

  #
  def to_hsh
    segments = {}
    self.expressions.each do |expression|
      segments.merge!(expression.to_hsh)
    end
    segments
  end

end
