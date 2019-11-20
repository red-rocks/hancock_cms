rails_spec = (Gem.loaded_specs["railties"] || Gem.loaded_specs["rails"])
version = rails_spec.version.to_s

mongoid = options[:skip_active_record]
pg = !!(options[:database] == "postgresql")
actual_rails_version = "6.0.0"
notsupported_rails_version = "6.1"


if Gem::Version.new(version) < Gem::Version.new(actual_rails_version) or Gem::Version.new(version) >= Gem::Version.new(notsupported_rails_version)
  puts "You are using an incorrect version of Rails (#{version})"
  puts "Please update for #{actual_rails_version}"
  puts "Stopping"
  exit 1
end

remove_file 'README.md'
create_file 'README.md', "## #{app_name}\nProject generated by HancockCMS\nORM: #{if mongoid then 'Mongoid' else 'ActiveRecord' end}\n\n"


####### GEMFILE #######

remove_file 'Gemfile'
create_file 'Gemfile' do <<-TEXT
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/\#{repo}.git" }
git_source(:gitlab) { |repo| "https://gitlab.com/\#{repo}.git" }

ruby '2.6.4'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'rails', '~> #{actual_rails_version}'#, '>= #{actual_rails_version}'
#{if mongoid then "gem 'mongoid', github: 'mongodb/mongoid'" else
  if pg then "gem 'pg'" else "gem 'ruby-mysql'\ngem 'mysql2'" end
end
}

# gem 'sass'
# gem 'sass-rails'#, '~> 5.0'
# gem 'compass', '1.0.3'
# gem 'compass-rails'
gem "bourbon"

# Use SCSS for stylesheets
# gem 'sass-rails'#, '~> 5.0'
gem 'sassc-rails'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem 'webpacker', '>= 4.0.0.rc.3'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt'#, '~> 3.1.12'

# # libvips + shrine
# gem 'ruby-vips'
# gem 'image_processing'

# gem "hancock_shrine", ">= 0.2.0"
# # gem "hancock_shrine", github: "red-rocks/hancock_shrine"
# # gem "hancock_shrine", github: "red-rocks/hancock_shrine", branch: 'dev'
## OR ##
# # gem 'shrine'
# # gem "shrine", "~> 2.0"
# # # gem "shrine", "~> 3.0"

# #{if mongoid then "gem 'shrine-mongoid'" end}

gem 'rails_admin', '~> 2.0'
# gem 'rails_admin', github: 'sferik/rails_admin' # TEMP

# gem 'rails_admin_multiple_file_upload'
# #{if mongoid then "gem 'rails_admin_user_abilities'#, '~> 0.2'" else "" end}
# gem 'rails_admin_user_abilities', github: "red-rocks/rails_admin_user_abilities"

# gem 'rails_admin_model_settings'#, '~> 0.4'
# gem 'rails_admin_model_settings', github: "red-rocks/rails_admin_model_settings", branch: 'rails6'

gem 'ack_rails_admin_settings', github: "red-rocks/rails_admin_settings"


# #{if mongoid then "gem 'hancock_cms_mongoid'" else "gem 'hancock_cms_activerecord'" end}, github: 'red-rocks/hancock_cms', branch: 'front'
# #{if mongoid then "gem 'hancock_cms_mongoid'" else "gem 'hancock_cms_activerecord'" end}, github: 'red-rocks/hancock_cms', branch: '3.0'
# #{if mongoid then "gem 'hancock_cms_mongoid'" else "gem 'hancock_cms_activerecord'" end}, github: 'red-rocks/hancock_cms', branch: 'rails6'
gem 'hancock_cms_mongoid', path: "/home/ack/www/redrocks/hancock"
# gem 'hancock_cms_mongoid', path: "/home/oleg/redrocks/hancock_cms"


# gem 'recaptcha', require: 'recaptcha/rails'

# gem 'responders', '~> 2.0'
gem 'responders', github: 'king601/responders'
gem 'devise-i18n'
gem 'devise'#, github: 'plataformatec/devise', branch: '5-rc'

# gem "hancock_devise"
gem "hancock_devise", git: "https://gitlab.com/redrocks/hancock_devise"

# gem 'slim-rails'#, '3.1.1'
# gem 'rs_russian'
gem 'cancancan'#, '~> 1.16'
#{if mongoid then "gem 'cancancan-mongoid'" end}

# gem 'cloner'
# gem 'unicorn'
gem 'x-real-ip'

gem 'font-awesome-sass'

# gem "actionpack-action_caching"
# gem "redis-store"
# gem 'redis-rails'
# # gem "redis-rack-cache"
# # gem 'mongo_session_store-rails5'
# gem 'redis-session-store'

gem "flutie"

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'#, '>= 3.3.0'
  gem 'listen'#, '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'#, '~> 2.0.0'

  gem 'ack_favicon_maker_rails'#, '~> 1.0.2'
  # gem 'ack_favicon_maker_rails', github: 'ack43/favicon_maker_rails'

  # gem 'rails_email_preview'#, '~> 1.0.3'

  # gem 'image_optim_pack'

  gem 'puma'#, '~> 3.0'

  gem "letter_opener"

  gem 'capistrano', '3.11'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  # gem 'capistrano-webpacker-precompile', require: false
  gem 'sshkit-sudo'
  gem 'net-ssh-shell'
end

# group :test do
#   gem 'rspec-rails'
#   gem 'database_cleaner'
#   gem 'email_spec'
#   #{if mongoid then "gem 'mongoid-rspec'" else "" end}
#   gem 'ffaker'
#   gem 'factory_girl_rails'
# end

# #{if mongoid then "gem 'mongo_session_store-rails5'" else "gem 'activerecord-session_store'" end}

# gem 'slim'
gem 'sprockets', '< 4'

gem 'coffee-rails'#, '~> 4.2'
gem 'uglifier'#, '>= 1.3.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  # gem 'sentry-raven'
  gem "god"
end


############ TEMP #############

# gem "jsoneditor-rails"
gem "jsoneditor-rails", git: "https://github.com/ack43/jsoneditor-rails"
# gem "rails_admin_jsoneditor"
gem "rails_admin_jsoneditor", git: "https://github.com/red-rocks/rails_admin_advanced_json_editor"
###############################


TEXT
end

RVM_RUBY_VERSION = "2.6.4"
# create_file '.ruby-version', "ruby-#{RVM_RUBY_VERSION}"
create_file '.ruby-gemset', "#{app_name.underscore}"

run "rvm #{RVM_RUBY_VERSION} do rvm gemset create #{app_name.underscore}"
run "rvm #{RVM_RUBY_VERSION}@#{app_name.underscore} do gem install bundler"
run "rvm #{RVM_RUBY_VERSION}@#{app_name.underscore} do bundle install --without production"

####### CONFIG #######

create_file 'config/locales/ru.yml' do <<-TEXT
ru:
  attributes:
    is_default: По умолчанию
  mongoid:
    models:
      item: Товар
    attributes:
      item:
        price: Цена
TEXT
end
# remove_file "config/locales/devise.en.yml"
# remove_file "config/locales/en.yml"

create_file 'config/navigation.rb' do <<-TEXT
# empty file to please simple_navigation, we are not using it
# See https://github.com/red-rocks/hancock_cms/blob/master/app/controllers/concerns/hancock/menu.rb
TEXT
end

if mongoid
create_file 'config/mongoid.yml' do <<-TEXT
development:
  clients:
    default:
      database: #{app_name.underscore}
      hosts:
          - localhost:27017
production:
  clients:
    default:
      database: #{app_name.underscore}
      hosts:
          - localhost:27017
test:
  clients:
    default:
      database: #{app_name.underscore}_test
      hosts:
          - localhost:27017
TEXT
end
FileUtils.cp(Pathname.new(destination_root).join('config', 'mongoid.yml').to_s, Pathname.new(destination_root).join('config', 'mongoid.yml.example').to_s)
else
remove_file 'config/database.yml'
create_file 'config/database.yml' do <<-TEXT
development:
  adapter: #{if pg then "postgresql" else "mysql2" end}
  database: #{app_name.underscore}_development
  pool: 5
  username: #{if pg then app_name.underscore else "root" end}
  password: #{if pg then app_name.underscore else "1" end}
  encoding: #{if pg then "unicode" else "utf8mb4" end}
  #{if pg then  "template: template0" else "charset: utf8mb4\n  collation: utf8mb4_unicode_ci" end}
TEXT
end
FileUtils.cp(Pathname.new(destination_root).join('config', 'database.yml').to_s, Pathname.new(destination_root).join('config', 'database.yml.example').to_s)
say "Please create a #{if pg then "PostgreSQL" else "MySQL/MariaDB" end} user #{if pg then app_name.underscore else "root" end} with password #{if pg then app_name.underscore else "1" end} and a database #{app_name.underscore}_development owned by him for development NOW.", :red
ask("Press <enter> when done.", true)
end

remove_file 'config/application.rb'
create_file 'config/application.rb' do <<-TEXT
require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
#{'#' if mongoid} require "active_record/railtie"
#{'#' if mongoid} require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module #{app_name.underscore.camelcase}
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.generators do |g|
      g.test_framework :rspec
      g.view_specs false
      g.helper_specs false
      g.feature_specs false
      g.template_engine :slim
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end

    config.i18n.locale = :ru
    config.i18n.default_locale = :ru
    config.i18n.available_locales = [:ru, :en]
    config.i18n.enforce_available_locales = true
    #{'config.active_record.schema_format = :sql' unless mongoid}

    #{'config.autoload_paths += %W(#{config.root}/extra)'}
    #{'config.eager_load_paths += %W(#{config.root}/extra)'}

    config.time_zone = 'Europe/Moscow'
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.paths << Rails.root.join("node_modules")

    # Don't generate system test files.
    config.generators.system_tests = nil  
  end
end
TEXT
end
