class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.author?
  end

  def update?
    user.author? && record.user_id == user.id
  end

  def destroy?
    user.author? && record.user_id == user.id
  end
end
