class Project < ActiveRecord::Base
  has_many :reports
  has_many :metrics
  has_many :menus


  validate :identifier, :presence => true, :uniqueness => true
  
  after_create :create_template_menus

  def create_template_menus
    Project.transaction do
      Menu.template.roots.each do |template_big_menu|

        big_menu = self.menus.create!(:name=>template_big_menu.name)
        
        template_big_menu.children.each do |template_sub_menu|
          m = self.menus.build(:name => template_sub_menu.name, :parent_id => big_menu.id)

          template_sub_menu.reports.each do |report|
            self.reports.build(report.clone_template_attributes(self.id))
          end
          m.save!
        end
      end
    end
  end

end