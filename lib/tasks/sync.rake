namespace :sync do

  task :projects => :environment do
    @gateway = Redmine::ProjectGateway.new
    
    page = 1
    
    response = @gateway.paginate(page)
    unless response.success?
      puts "request failure"
    end
    
    projects = response.data
    
    pp projects
    while projects.present?
      projects.each do |project|
        proj = Project.where(:identifier => project["identifier"]).first || Project.new(:name => project["name"], :identifier => project["identifier"])
        
        # clusters = project["fserver_instances"] || []
        #         
        #         exist_oids = proj.clusters.map(&:oid)
        #         remote_oids = clusters.map{|cluster| cluster["id"] unless cluster["is4test"]}.compact
        #         
        #         (remote_oids - exist_oids).each do |new_oid|
        #           cluster = clusters.detect{|c| c["id"] == new_oid }
        #           proj.clusters.build(:name => cluster["name"], :oid => cluster["id"], :base => cluster["fserver_cluster_id"])
        #         end
        #         
        #         proj.clusters.where(:oid => (exist_oids - remote_oids)).destroy_all
        
        if proj.save
          puts "save project #{proj.identifier}"
        else
          puts "failure project #{proj.identifier}"
          puts proj.errors.full_messages.join(", ")
        end
        
      end
      
      page += 1
      response = @gateway.paginate(page)
      projects = response.data
      
      pp "next page #{page}"
      pp projects
    end
  end
end