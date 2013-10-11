class Expression < ActiveRecord::Base
  validates_presence_of :value, :if => proc{|e| e.operator == "in"}
  validate :validate_in_datetime

  belongs_to :segment

  #
  EXPRESSION_OPERATORS = ["gt","gte", "lt", "lte", "eq", "handler", "in"]

  def sequence
    result = {}
    if value_type == "sql_datetime" or value_type == "Date" and time_type == "relative"
      w_value= value_wrapper(value)
      if operator == "eq"
        gte={"op"=>"gte", "expr"=>"$date_add(#{w_value})","type"=>"VAR"}
        lte={"op"=>"lte", "expr"=>"$date_add(#{w_value})","type"=>"VAR"}
        result[name] = [gte,lte]
      else # We will never encounter the situtation that operator is 'in' while time_type is "relative"
        result[name] = [{"op"=>operator, "expr"=>"$date_add(#{w_value})", "type"=>"VAR"}]
      end
    else
      expression={"op"=>operator}
      expression["type"] = "CONST"
      result[name]=[expression]
      if operator == "in"
        expression["expr"] = value.split(",").map{|x|value_wrapper(x)}.join("|")
      else
        expression["expr"] = value_wrapper(value)
      end
    end
    result
  end

  private

  def value_wrapper(original_value)
    if value_type == "sql_bigint"
      original_value.to_i
    else
      original_value
    end
  end

  def validate_in_datetime
    if operator == "in" and value_type == "sql_datetime"
      is_matched = /^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])(,\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01]))*/.match(value).present?
      if is_matched
        value.split(",").each do |date|
          begin
            Date.parse(date)
          rescue
            is_matched = false
            break
          end
        end
      end
      if not is_matched
        errors.add(:value, "value is invalid")
      end
    end
  end

end
