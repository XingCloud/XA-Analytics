class UserPreference < ActiveRecord::Base
  validates_presence_of :user, :key, :value
  validates_uniqueness_of :key, :scope => :user
end
