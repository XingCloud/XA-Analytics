namespace :sync do
  
  # paginate_do 1, gateway, paginate, :project_id => 3
  #  => gateway.paginate(1, :project_id => 3)
  def paginate_do(page, gateway, *args, &block)
    method_name = args.first
    other_args = args[1..-1]
    response = gateway.send(method_name, page, *other_args)
    
    unless response.success?
      raise "Request Failure in Page: #{page}, Error: #{response.error}"
    end
    
    items = response.data
    
    if items.blank?
      puts "finish..."
      return
    else
      yield items
      paginate_do(page + 1, gateway, *args, &block)
    end
  end
  
  
  task :projects => :environment do
    @gateway = Redmine::ProjectGateway.new
    
    paginate_do(1, @gateway, :paginate) do |projects|
      projects.each do |project|
        proj = Project.where(:identifier => project["identifier"]).first || Project.new(:name => project["name"], :identifier => project["identifier"])
        
        if proj.save
          puts "save project #{proj.identifier}"
        else
          puts "failure project #{proj.identifier}"
          puts proj.errors.full_messages.join(", ")
        end
      end
    end
  end
  
  task :events => :environment do
    @geteway = Fserver::EventGateway.new
    
    Project.all.each do |project|
      paginate_do(1, @gateway, :paginate, :project => project) do |events|
        events.each do |event|
          project.events.find_or_create_by_name(event["name"])
        end
      end
    end
    
    
  end
end