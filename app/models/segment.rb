class Segment < ActiveRecord::Base

  has_many :expressions, :dependent => :destroy
  belongs_to :project

  accepts_nested_attributes_for :expressions, :allow_destroy => true

  validates :name, :presence => true

  DEFAULT_USER_ATTRIBUTES = ["register_time", "last_login_time", "first_pay_time", "last_pay_time", "grade", "game_time", "pay_amount", "language", "platform"]

  scope :template, where(:project_id => nil)

  scope :customs, lambda { |project| where(:project_id => project.id) }

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

  def short_attributes
    {:id => id, :name => name}
  end

  def js_attributes
    attributes.merge({:expressions_attributes => expressions.map(&:attributes)})
  end

end
