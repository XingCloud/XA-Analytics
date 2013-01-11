class Segment < ActiveRecord::Base

  has_many :expressions, :dependent => :destroy
  has_many :translations, :foreign_key => :rid, :conditions => ["translations.rtype = ?", "Segment"], :dependent => :destroy
  belongs_to :project

  accepts_nested_attributes_for :expressions, :allow_destroy => true

  validates :name, :presence => true
  scope :template, where(:project_id => nil)

  def to_hsh
    if expressions.length > 0
      segments = {}
      self.expressions.each do |expression|
        segments.merge!(expression.to_hsh)
      end
      segments
    end
  end

  def short_attributes
    {:id => id, :name => name}
  end

  def js_attributes
    attributes.merge({:expressions_attributes => expressions.map(&:attributes)})
  end

  def sequence
    if expressions.length > 0
      results = {}
      expressions.each do |expression|
        results.merge!(expression.sequence)
      end
      results
    else
      nil
    end
  end
end
