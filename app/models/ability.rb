class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    pp user
    if user.roles.blank?
      can :index ,Project
    elsif user.admin?
      can :manage, :all
    elsif user.role? :analytics_admin
      can :manage, [Project, Report,Menu]
    else
      user.roles.each do |role|
        can :read, Project
        can :read, Menu, :id => role.menus.map(&:id)
      end
    end

    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end