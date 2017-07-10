class UserPolicy < ApplicationPolicy

  def index?
    user ? user.can_view_users? : false
  end

  def show?
    user ? user.can_view_users? : false
  end

  def edit?
    user ? user.can_edit_users? : false
  end

  def update?
    user ? user.can_edit_users? : false
  end

  def new?
    user ? user.can_create_users? : false
  end

  def create?
    user ? user.can_create_users? : false
  end

end