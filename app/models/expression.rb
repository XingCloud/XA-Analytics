class Expression < ActiveRecord::Base
  belongs_to :segment

  #
  EXPRESSION_OPERATORS = ["gt","gte", "lt", "lte", "eq"]

  # 组装给后端的数据
  def to_hsh
    if self.name.match("time")
      {self.name => {"$handler" => "DateSplittor"}}
    else
      {self.name => {"$#{self.operator}" => self.value}}
    end
  end

end
