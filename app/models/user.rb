class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_permissions
  has_many :permissions, through: :user_permissions

  def list_permissions
    self.permissions.pluck(:name).uniq
  end

  def can_view_users?
    self.list_permissions.include?('can_view_users')
  end

  def can_edit_users?
    self.list_permissions.include?('can_edit_users')
  end

  def can_create_users?
    self.list_permissions.include?('can_create_users')
  end

  def can_view_permissions?
    self.list_permissions.include?('can_view_permissions')
  end

  def can_edit_permissions?
    self.list_permissions.include?('can_edit_permissions')
  end

  def can_create_permissions?
    self.list_permissions.include?('can_create_permissions')
  end

end
