# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Bot.create!([
  { username: "botusername" },
])

@admin = User.create!(username: 'admin',
                      email: 'admin@admin.com',
                      admin: true,
                      password: 'welcome',
                      password_confirmation: 'welcome')

Bot.all.each do |bot|
  x = Permission.create!(action: "vote", bot: bot)
  y = Permission.create!(action: "comment", bot: bot)
  z = Permission.create!(action: "resteem", bot: bot)
  [x,y,z].each do |perm|
    UserPermission.create!(user_id: @admin.id, permission_id: perm.id)
  end
end

Rails.logger.info { "Created #{Bot.count} bots, #{Permission.count} permissions, and #{User.count} users." }
