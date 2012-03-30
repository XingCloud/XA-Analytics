class Project < ActiveRecord::Base
  has_many :reports
  has_many :metrics
  has_many :menus
  
  validate :identifier, :presence => true, :uniqueness => true
  
  after_create :create_template_menus

  def create_template_menus
    Project.transaction do
      Menu.template.roots.each do |template_big_menu|
        big_menu = self.menus.create(:name=>template_big_menu.name)

        template_big_menu.children.each do |template_sub_menu|
          m = self.menus.create(:name => template_sub_menu.name)
          m.move_to_child_of(big_menu)
          template_sub_menu.reports.each do |report|
            m.reports << report.clone_as_template(self.id)
          end
        end
      end
    end
  end
  
end