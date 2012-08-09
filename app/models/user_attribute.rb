class UserAttribute < ActiveRecord::Base
  belongs_to :project

  ATYPES = %w{sql_string sql_bigint sql_datetime}

  validates_presence_of :name, :atype
  validates :atype, :inclusion => {:in => ATYPES}
  validates_format_of :name, :with => /^[a-zA-Z0-9_]+$/i
  validates_format_of :gpattern, :with => /^\d+(,\d+)*$/, :if => proc{|m|m.gpattern.present?}

  def serialize
    {
        :name => name,
        :nickname => nickname,
        :type => atype,
        :groupby_pattern => gpattern
    }
  end
end
