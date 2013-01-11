class Expression < ActiveRecord::Base
  validates_presence_of :value, :if => proc{|e| e.operator == "in"}
  validate :validate_in_datetime

  belongs_to :segment

  #
  EXPRESSION_OPERATORS = ["gt","gte", "lt", "lte", "eq", "handler", "in"]

  def sequence
    if operator == "eq"
      {name => value_wrapper(value)}
    elsif operator == "in"
      {name => value.split(",").map{|item| value_wrapper(item)}}
    elsif operator == "handler"
      {name => {"$handler" => "DateSplittor", "offset" => value_wrapper.present? ? value_wrapper(value) : 0}}
    else
      {name => {"$#{operator}" => value_wrapper(value)}}
    end
  end

  private

  def value_wrapper(original_value)
    if value_type == "int"
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
