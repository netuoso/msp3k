class PermissionPolicy < ApplicationPolicy

  def index?
    user ? user.can_view_permissions? : false
  end

  def show?
    user ? user.can_view_permissions? : false
  end

  def edit?
    user ? user.can_edit_permissions? : false
  end

  def update?
    user ? user.can_edit_permissions? : false
  end

  def new?
    user ? user.can_create_permissions? : false
  end

  def create?
    user ? user.can_create_permissions? : false
  end

end