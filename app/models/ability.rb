class Ability
  include CanCan::Ability

  def initialize(user)  
    user ||= User.new
    
    # anyone logged in can register?
    can [:create, :verify, :ask_code], User
    
    # one should have no way to access other's profile
    #can :read, User, :id => user.id if user.has_role? :ordinary_user
    can :read, Book if user.has_role? :ordinary_user
    #can :read, Appointment if user.has_role? :ordinary_user
    can :create, Appointment if user.has_role? :ordinary_user
    can [:read, :update, :user_index], Appointment, :id => user.id if user.has_role? :ordinary_user
    #can [:read, :edit, :update, :info, :change_password, :write_password], User, :id => user.id if user.has_role? :ordinary_user
    can [:read, :info, :change_password, :write_password, :update, :put], User, :id => user.id if user.has_role? :ordinary_user
    #can :manage, User, :id => user.id if user.has_role? :ordinary_user
    #can :update, User, :role => 1 if user.has_role? :ordinary_user
    can [:read, :user_index], Record, :id => user.id if user.has_role? :ordinary_user
    
    cannot :index, Appointment unless user.has_role? :operator
    can :manage, Appointment if user.has_role? :operator
    can :statistics, User if user.has_role? :operator
    can :create, Book if user.has_role? :operator
    
    can :manage, Book if user.has_role? :admin
    #can [:enpower, :set_admin], User if user.has_role? :admin
    
    can [:enpower, :set_admin], User, :role => 1 .. 14 if user.has_role? :super_admin
  end
end
