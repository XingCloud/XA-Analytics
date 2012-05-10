class Expression < ActiveRecord::Base
  belongs_to :segment

  #
  EXPRESSION_OPERATORS = ["gt","gte", "lt", "lte", "eq","handler"]

  # 组装给后端的数据
  def to_hsh
    if self.name.match("time")
      {self.name => {"$handler" => "DateSplittor"}}
    else
      if self.operator.match('eq')
        if self.value_type == 'int'
          {self.name => self.value.to_i}
        else
          {self.name => self.value}
        end
      else
        if self.value_type == 'int'
          {self.name => {"$#{self.operator}" => self.value.to_i}}
        else
          {self.name => {"$#{self.operator}" => self.value}}
        end
      end
    end
  end

end
