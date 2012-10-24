class Broadcasting < ActiveRecord::Base
  attr_accessible :message

  def js_attributes()
    {:message => self.message}
  end
end
