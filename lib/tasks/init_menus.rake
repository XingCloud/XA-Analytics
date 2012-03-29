namespace :init do
  desc "Initialize menus form all projects"
  task :menus => :environment do

    Project.all.each do |project|
      if project.menus.blank?
        project.create_template_menus
        puts "#{project.identifier} finish."
      else
        puts "menus exists."
      end

    end
    puts "finish."

  end
end