class UserAttribute < ActiveRecord::Base
  belongs_to :project

  ATYPES = %w{sql_string sql_bigint sql_datetime}

  validates_presence_of :name, :atype
  validates :atype, :inclusion => {:in => ATYPES}
  validates_format_of :name, :with => /^[a-zA-Z0-9_]+$/i
  validates_format_of :gpattern, :with => /^\d+(,\d+)*$/, :if => proc{|m|m.gpattern.present? and m.atype == "sql_bigint"}
  validate :validate_datetime_gpattern

  before_save :check_gpattern

  def serialize
    {
        :name => name,
        :nickname => nickname,
        :type => atype,
        :groupby_pattern => gpattern
    }
  end

  def validate_datetime_gpattern
    if gpattern.present? and atype == "sql_datetime"
      is_matched = /^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])(,\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01]))*/.match(gpattern).present?
      if is_matched
        gpattern.split(",").each do |date|
          begin
            Date.parse(date)
          rescue
            is_matched = false
            break
          end
        end
      end
      if not is_matched
        errors.add(:gpattern, "gpattern is invalid")
      end
    end
  end

  def check_gpattern
    if self.atype == "sql_bigint"
      self.gpattern ||= "0,10,30,50,100"
    end
  end
end
