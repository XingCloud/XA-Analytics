class MenuReport < ActiveRecord::Base
  belongs_to :menu
  belongs_to :report
end
