class Expression < ActiveRecord::Base
  belongs_to :segment

  #
  EXPRESSION_OPERATORS = ["gt","gte", "lt", "lte", "eq","handler"]

  def sequence
    if operator == "eq"
      {name => value_wrapper}
    elsif operator == "handler"
      {name => {"$handler" => "DateSplittor", "offset" => value_wrapper.present? ? value_wrapper : 0}}
    else
      {name => {"$#{operator}" => value_wrapper}}
    end
  end

  private

  def value_wrapper
    if value_type == "int"
      value.to_i
    else
      value
    end
  end

end
