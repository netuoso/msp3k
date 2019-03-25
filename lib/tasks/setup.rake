desc 'Set up the project, clear out database and recreate'
task :setup => :environment do
  User.delete_all
  Bot.delete_all
  Permission.delete_all
  UserPermission.delete_all
  MspDelegator.delete_all
  PaperTrail::Version.delete_all

  ['db:migrate', 'db:seed'].each { |cmd| system "rake #{cmd} RAILS_ENV=#{Rails.env}" }
end
