class Translation < ActiveRecord::Base
  validates_presence_of :rid, :rtype, :rfield, :locale, :content
end
