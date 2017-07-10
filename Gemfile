source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'

gem 'sqlite3'
gem 'puma', '~> 3.7'

gem 'sass-rails', '~> 5.0'
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'twitter-bootstrap-rails'

gem 'pundit'
gem 'devise'
gem 'devise-bootstrap-views'

gem 'paper_trail'

gem 'radiator'
gem 'steem_api'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :production do
  gem 'pg'
end
