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
        proj = Project.where(:identifier => project["identifier"]).first
        new_flag = false
        if proj.nil?
          proj = Project.new(:name => project["name"], :identifier => project["identifier"])
          new_flag = true
        end

        if proj.save
          if new_flag
            proj.create_template_reports
            proj.create_template_menus
          end
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

  # 所有项目初始化菜单
  task :init_menus => :environment do
    menus = Menu.all(:conditions => 'status = 0') # template menus
    Project.all.each do |p|
       p << menus
    end
  end

end