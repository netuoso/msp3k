# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Bot.create([
  { :username => "centerlink" },
  { :username => "minnowsupport" },
  { :username => "msp-lovebot" },
  { :username => "msp-africabot" },
  { :username => "msp-creativebot" },
  { :username => "msp-shanebot" }
])

Permission.create([
  { :name => "can_view_users" },
  { :name => "can_edit_users" },
  { :name => "can_create_users" },
  { :name => "can_view_permissions" },
  { :name => "can_edit_permissions" },
  { :name => "can_create_permissions" }
])

Rails.logger.info { "Created #{Bot.count} bots." }

admin = User.create!(email: 'chem.drew@gmail.com',
             admin: true,
             password: 'welcome',
             password_confirmation: 'welcome')

Permission.all.each do |permission|
  UserPermission.create(user_id: admin.id, permission_id: permission.id)
end
