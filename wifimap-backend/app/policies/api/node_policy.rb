class NodePolicy < ApplicationPolicy
  def initialize(user, node)
    @user = user
    @node = node
  end

  def index?
    false
  end

  def show?
    false
  end

  def new?
    false
  end

  def create?
    false
  end

  def edit?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end
end
