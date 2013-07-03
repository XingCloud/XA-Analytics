require "pp"
desc "migrate 'handler' to support selecting relative time in expression"
task :migrate_handler => :environment do
  expressions = Expression.all
  expressions.each do |expression|
    if expression.time_type.nil?
      expression.time_type = "absolute"
    end
    if expression.operator == "handler"
      expression.time_type = "relative"
      expression.operator = "eq"
    end

    if expression.value.nil? or expression.value.eql?("")
      expression.value="0"
    end

    if ! expression.save
      pp "get error #{expression.id}"
    end

  end
end