class LocationPolicy < ApplicationPolicy
  def initialize(user, location)
    @user = user
    @ndoe = location
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    @user.admin? if not @user.nil?
  end

  def edit?
    @user.admin? if not @user.nil?
  end

  def create?
    @user.admin? if not @user.nil?
  end

  def update?
    @user.admin? if not @user.nil?
  end

  def destroy?
    @user.admin? if not @user.nil?
  end
end
