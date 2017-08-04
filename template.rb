rails_spec = (Gem.loaded_specs["railties"] || Gem.loaded_specs["rails"])
version = rails_spec.version.to_s

mongoid = options[:skip_active_record]
actual_rails_version = "5.0.1"
notsupported_rails_version = "6.x"

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

gem 'rails', '~> #{actual_rails_version}'#, '>= #{actual_rails_version}'
#{if mongoid then "gem 'mongoid'" else "gem 'pg'" end}

gem 'sass'
gem 'sass-rails'#, '~> 5.0'
gem 'compass'
gem 'compass-rails'

gem 'rails_admin', '~> 1.1'

# #{if mongoid then "gem 'glebtv-mongoid-paperclip'" else "gem 'paperclip'" end}
# gem "image_optim"
# gem "paperclip-optimizer"
# gem 'ack-paperclip-meta', github: "red-rocks/paperclip-meta"

# gem 'rails_admin_multiple_file_upload'
gem 'rails_admin_user_abilities'#, '~> 0.2'
# gem 'rails_admin_user_abilities', github: "red-rocks/rails_admin_user_abilities"
gem 'rails_admin_model_settings'#, '~> 0.3'
# gem 'rails_admin_model_settings', github: "red-rocks/rails_admin_model_settings"

# #{if mongoid then "gem 'hancock_cms_mongoid'" else "gem 'hancock_cms_activerecord'" end}, github: 'red-rocks/hancock_cms', branch: '2.0'

# gem 'recaptcha', require: 'recaptcha/rails'
# gem 'glebtv-simple_captcha'

gem 'slim-rails', '3.1.1'
gem 'rs_russian'
gem 'cancancan', '~> 1.16'

# gem 'cloner'
gem 'unicorn'
gem 'x-real-ip'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen'#, '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'#, '~> 2.0.0'

  gem 'ack_favicon_maker_rails'#, '~> 1.0.1'
  # gem 'ack_favicon_maker_rails', github: 'ack43/favicon_maker_rails'

  # gem 'rails_email_preview'#, '~> 1.0.3'

  gem 'image_optim_pack'

  gem 'puma'#, '~> 3.0'
end

group :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'email_spec'
  #{if mongoid then "gem 'mongoid-rspec'" else "" end}
  gem 'ffaker'
  gem 'factory_girl_rails'
end

# #{if mongoid then "gem 'mongo_session_store-rails5'" else "gem 'activerecord-session_store'" end}

gem 'slim'
gem 'sprockets'

gem 'coffee-rails'#, '~> 4.2'
gem 'uglifier'#, '>= 1.3.0'

# gem 'jbuilder', '~> 2.5'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  # gem 'sentry-raven'
  gem "god"
end

gem 'glebtv_mongoid_userstamp', '~> 0.7'
TEXT
end

RVM_RUBY_VERSION = "2.4.1"#"2.3.3"
create_file '.ruby-version', "#{RVM_RUBY_VERSION}\n"
create_file '.ruby-gemset', "#{app_name.underscore}\n"

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
remove_file "config/locales/devise.en.yml"
remove_file "config/locales/en.yml"

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
  adapter: postgresql
  encoding: unicode
  database: #{app_name.underscore}_development
  pool: 5
  username: #{app_name.underscore}
  password: #{app_name.underscore}
  template: template0
TEXT
end
FileUtils.cp(Pathname.new(destination_root).join('config', 'database.yml').to_s, Pathname.new(destination_root).join('config', 'database.yml.example').to_s)
say "Please create a PostgreSQL user #{app_name.underscore} with password #{app_name.underscore} and a database #{app_name.underscore}_development owned by him for development NOW.", :red
ask("Press <enter> when done.", true)
end

remove_file 'config/application.rb'
create_file 'config/application.rb' do <<-TEXT
require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
#{'#' if mongoid}require "active_record/railtie"
require "action_controller/railtie"
# require "active_job/railtie"
# require "action_cable/engine"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module #{app_name.underscore.camelcase}
  class Application < Rails::Application
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
  end
end
TEXT
end
