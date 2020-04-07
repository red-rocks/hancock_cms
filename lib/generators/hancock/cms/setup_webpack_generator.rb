require 'rails/generators'
# require "rails/generators/rails/app/app_generator"

module Hancock::Cms
  class SetupWebpackGenerator < Rails::Generators::Base

    desc 'Hancock CMS Carcass generator for Webpacker'
    def install

      def ask_with_timeout(question, timeout = 5)
        # ask(question)
        # temp
        begin
          Timeout::timeout(timeout) {
            ask("#{question} | U have only #{timeout} second(s)!")
          }
        rescue
          puts "y"
          "y"
        end
      end


####### SIMPLE FORM ######

generate "simple_form:install" if ["yes", "y"].include?(ask_with_timeout("generate `simple_form:install`? (y or yes)").downcase.strip)


####### MODELS #######

generate "hancock:cms:ability" if ["yes", "y"].include?(ask_with_timeout("generate `hancock:cms:ability`? (y or yes)").downcase.strip)

remove_file 'app/models/user.rb'
create_file 'app/models/user.rb' do <<-TEXT
class User
  include Mongoid::Document

  if defined? RailsAdminUserAbilities
    ######################### RailsAdminUserAbilities #########################
    def self.rails_admin_user_defined_visible_actions
      [:user_abilities]
    end
    has_one :ability, class_name: "RailsAdminUserAbilities::UserAbility", as: :rails_admin_user_abilitable
    scope :for_rails_admin, -> { where(:roles.in => ['admin', 'manager']) } # could be any you want, just need to
    ###########################################################################
  end
  
  include Hancock::Users::Devise if defined?(Devise)

  include Hancock::Users::Roles
  def self.default_admin_email;    "admin@#{app_name.dasherize.downcase}.ru"; end
  def self.default_manager_email;  "manager@#{app_name.dasherize.downcase}.ru"; end


  rails_admin do
    navigation_icon 'icon-user'
    list do
      field :name
    end

    edit do
      group :login do
        active false
        field :name, :string
      end
    end

  end


  # attr_accessor :token_2fa # i think it will be shared
  # include Hancock::Users::Authy if defined?(Authy)

  # include Hancock::Users::GoogleAuthenticator if defined?(GoogleAuthenticatorRails)
  
end

TEXT
end


####### DEVISE #######

generate "devise:install" if ["yes", "y"].include?(ask_with_timeout("generate `devise:install`?(y or yes)").downcase.strip)
gsub_file 'config/initializers/devise.rb', "'please-change-me-at-config-initializers-devise@example.com'", "'noreply@#{app_name.dasherize.downcase}.ru'"
gsub_file 'config/initializers/devise.rb', "# config.mailer = 'Devise::Mailer'", "config.mailer = 'Hancock::DeviseMailer'"

if ["yes", "y"].include?(ask_with_timeout("Set Hancock's layout for devise? (y or yes)").downcase.strip)
_sessions_layout      = Devise::SessionsController._layout       == "hancock/devise/sessions"
_registration_layout  = Devise::RegistrationsController._layout  == "hancock/devise/registrations"
_confirmations_layout = Devise::ConfirmationsController._layout  == "hancock/devise/confirmations"
_unlocks_layout       = Devise::UnlocksController._layout        == "hancock/devise/unlocks"
_passwords_layout     = Devise::PasswordsController._layout      == "hancock/devise/passwords"
if !_sessions_layout or !_registration_layout or !_confirmations_layout or !_unlocks_layout or !_passwords_layout
inject_into_file 'config/initializers/devise.rb', after: /^end/ do <<-TEXT

Rails.application.config.to_prepare do
  #{'Devise::SessionsController.layout        "hancock/devise/sessions"'      unless _sessions_layout }
  #{'Devise::RegistrationsController.layout   "hancock/devise/registrations"' unless _registration_layout }
  #{'Devise::ConfirmationsController.layout   "hancock/devise/confirmations"' unless _confirmations_layout }
  #{'Devise::UnlocksController.layout         "hancock/devise/unlocks"'       unless _unlocks_layout }
  #{'Devise::PasswordsController.layout       "hancock/devise/passwords"'     unless _passwords_layout }
end
TEXT
end
end
end
generate "devise", "User", "--routes=false" if ["yes", "y"].include?(ask_with_timeout("generate `devise User --routes=false`?(y or yes)").downcase.strip)


####### ROUTES #######


if ["yes", "y"].include?(ask_with_timeout("Set Hancock's routes? (y or yes)").downcase.strip)
remove_file 'config/routes.rb'
create_file 'config/routes.rb' do <<-TEXT
Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions:       'hancock/sessions',
    registrations:  'hancock/registrations',
    passwords:      'hancock/passwords',
    unlocks:        'hancock/unlocks'
  }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  hancock_cms_routes
end
TEXT
end
end


####### RECAPTCHA #######


if ["yes", "y"].include?(ask_with_timeout("Set Hancock's recaptcha? (y or yes)").downcase.strip)
remove_file 'config/initializers/recaptcha.rb'
create_file 'config/initializers/recaptcha.rb' do <<-TEXT
if defined?(Recaptcha)
  Recaptcha.configure do |config|
    # v4
    if Rails.env.production?
      config.site_key     = (Rails.application.credentials.recaptcha || {})[:site_key] || ENV["#{app_name.underscore.upcase}_RECAPTCHA_SITE_KEY"]
      config.secret_key   = (Rails.application.credentials.recaptcha || {})[:secret_key] || ENV["#{app_name.underscore.upcase}_RECAPTCHA_SECRET_KEY"]
    else
      config.site_key     = (Rails.application.credentials.recaptcha || {})[:site_key]
      config.secret_key   = (Rails.application.credentials.recaptcha || {})[:secret_key]
    end
  end
end

TEXT
end
end


####### LETTER_OPENER ######

if true # ["yes", "y"].include?(ask_with_timeout("Set Hancock's letter_opener config? (y or yes)").downcase.strip)
inject_into_file "config/environments/development.rb", before: "# Don't care if the mailer can't send." do <<-TEXT
config.action_mailer.delivery_method = :letter_opener if defined?(LetterOpener)
TEXT
end
end


####### INITIALIZERS #######

add_assets_precompiled = ["*.svg", 'ckeditor/*', 'codemirror.js', 'codemirror.css', 'codemirror/**/*']
if (Rails.application.config.assets.precompile & add_assets_precompiled).length < add_assets_precompiled.length
append_to_file 'config/initializers/assets.rb' do <<-TEXT
Rails.application.config.assets.precompile += %w( *.svg )
Rails.application.config.assets.precompile += %w( ckeditor/* )
Rails.application.config.assets.precompile += %w( codemirror.js codemirror.css codemirror/**/* )
TEXT
end
end


if mongoid
if defined?(Shrine) and defined?(Ckeditor)
generate "ckeditor:install", "--orm=mongoid", "--backend=shrine" if ["yes", "y"].include?(ask_with_timeout("generate `ckeditor:install --orm=mongoid --backend=shrine`?(y or yes)").downcase.strip)
require 'ckeditor/orm/mongoid'
remove_file 'app/models/ckeditor/asset.rb'
create_file 'app/models/ckeditor/asset.rb' do <<-TEXT
# frozen_string_literal: true

class Ckeditor::Asset
  include Hancock::Ckeditor::Asset
end
TEXT

remove_file 'app/models/ckeditor/picture.rb'
create_file 'app/models/ckeditor/picture.rb' do <<-TEXT
# frozen_string_literal: true

class Ckeditor::Picture < Ckeditor::Asset
  include Hancock::Ckeditor::Picture
end
TEXT

remove_file 'app/models/ckeditor/attachment_file.rb'
create_file 'app/models/ckeditor/attachment_file.rb' do <<-TEXT
# frozen_string_literal: true

class Ckeditor::AttachmentFile < Ckeditor::Asset
  include Hancock::Ckeditor::AttachmentFile
end
TEXT
end
end

else
# if defined?(Shrine) and defined?(Ckeditor)
#   generate "ckeditor:install", "--orm=active_record", "--backend=shrine" if ["yes", "y"].include?(ask_with_timeout("generate `ckeditor:install --orm=active_record --backend=shrine`?(y or yes)").downcase.strip)
# end
end
if File.exists?(Rails.root.join 'config/initializers/ckeditor.rb')
  gsub_file 'config/initializers/ckeditor.rb', "# config.image_file_types = %w(jpg jpeg png gif tiff)", "config.image_file_types = %w(jpg jpeg png gif tiff gif svg)"
  gsub_file 'config/initializers/ckeditor.rb', "# config.authorize_with :cancan",                       "# config.authorize_with :cancancan"
  gsub_file 'config/initializers/ckeditor.rb', "# config.assets_languages = ['en', 'uk']",              "config.assets_languages = ['en', 'ru']"
end

if mongoid and ["yes", "y"].include?(ask_with_timeout("Set Hancock's config for cookies_serializer? (y or yes)").downcase.strip)
remove_file 'config/initializers/cookies_serializer.rb'
create_file 'config/initializers/cookies_serializer.rb' do  <<-TEXT
# Be sure to restart your server when you modify this file.
# json serializer breaks Devise + Mongoid. DO NOT ENABLE
# See https://github.com/plataformatec/devise/pull/2882
# Rails.application.config.action_dispatch.cookies_serializer = :json
Rails.application.config.action_dispatch.cookies_serializer = :marshal
TEXT
end
end

gsub_file 'config/initializers/filter_parameter_logging.rb', "[:password]", "[:password, :password_confirmation]"

# # generate 'paperclip_optimizer:install'
# # remove_file 'config/initializers/paperclip_optimizer.rb'
# generate "hancock:cms:paperclip_optimizer" if ["yes", "y"].include?(ask_with_timeout("generate `hancock:cms:paperclip_optimizer`? (y or yes)").downcase.strip)

# # generate 'rails_email_preview:install'
# # remove_file 'app/mailer_previews/contact_mailer_preview.rb'
# # create_file 'app/mailer_previews/contact_mailer_preview.rb' do <<-TEXT
# # class ContactMailerPreview
# #   def new_message_email
# #     Hancock::Feedback::ContactMailer.new_message_email(Hancock::Feedback::ContactMessage.all.to_a.sample)
# #   end
# # end
# # TEXT
# # end

generate "hancock:cms:config" if ["yes", "y"].include?(ask_with_timeout("generate `hancock:cms:config`? (y or yes)").downcase.strip)

generate "hancock:cms:rack" if ["yes", "y"].include?(ask_with_timeout("generate `hancock:cms:rack`? (y or yes)").downcase.strip)

generate "hancock:cms:admin" if ["yes", "y"].include?(ask_with_timeout("generate `hancock:cms:admin`? (y or yes)").downcase.strip)

if ["yes", "y"].include?(ask_with_timeout("Set Hancock's config for session_store? (y or yes)").downcase.strip)
remove_file 'config/initializers/session_store.rb'
if mongoid
create_file 'config/initializers/session_store.rb' do  <<-TEXT
# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_#{app_name.tableize.singularize}_session'
Rails.application.config.session_store :mongoid_store
TEXT
end
else
generate 'active_record:session_migration'
create_file 'config/initializers/session_store.rb' do  <<-TEXT
# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_#{app_name.tableize.singularize}_session'
Rails.application.config.session_store :active_record_store
TEXT
end
end
end

# gsub_file 'config/secrets.yml', 'secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>', "secret_key_base: <%= ENV['#{app_name.underscore.upcase}_SECRET_KEY_BASE'] %>"



####### CONTROLLERS #######


unless ApplicationController < Hancock::Controller
remove_file 'app/controllers/application_controller.rb'
create_file 'app/controllers/application_controller.rb' do <<-TEXT
class ApplicationController < ActionController::Base

  # def self.hancock_check_errors
  #   true
  # end

  include Hancock::Controller
end
TEXT
end
end


###### HANCOCK OTHERS ######

unless mongoid
generate "hancock:cms:migration"
# https://github.com/RolifyCommunity/rolify/issues/444
generate "rails_admin_settings:migration"
end

if ["yes", "y"].include?(ask_with_timeout("Set Hancock's layout? (y or yes)").downcase.strip)
remove_file 'app/views/layouts/application.html.erb'
generate "hancock:cms:layout"
end

if mongoid
run 'rails r "User.generate_first_admin_user"'
end

# if ["yes", "y"].include?(ask_with_timeout("Set Hancock's assets? (y or yes)").downcase.strip)
# remove_file 'app/assets/stylesheets/application.css'
# remove_file 'app/assets/javascripts/application.js'
# generate "hancock:cms:assets", app_name
# end

if ["yes", "y"].include?(ask_with_timeout("Set Hancock's robots.txt? (y or yes)").downcase.strip)
remove_file 'public/robots.txt'
generate "hancock:cms:robots", app_name
end

# if ["yes", "y"].include?(ask_with_timeout("Set Hancock's unicorn config? (y or yes)").downcase.strip)
# #god+unicorn
# generate "hancock:cms:unicorn_god", app_name
# end
# if ["yes", "y"].include?(ask_with_timeout("Set Hancock's scripts? (y or yes)").downcase.strip)
# #scripts
# generate "hancock:cms:scripts", app_name
# gsub_file 'config/puma.rb', /^port\s+ENV\.fetch\(\"PORT\"\) \{ 3000 \}/, '# port        ENV.fetch("PORT") { 3000 }'
# end

# FileUtils.cp(Pathname.new(destination_root).join('config', 'secrets.yml').to_s, Pathname.new(destination_root).join('config', 'secrets.yml.example').to_s)

unless mongoid
generate "paper_trail:install"
generate "friendly_id"
run 'grep -rl "ActiveRecord::Migration$" db | xargs sed -i "s/ActiveRecord::Migration/ActiveRecord::Migration[5.1]/g"'
rake "db:migrate"
end

# generate "rspec:install" if ["yes", "y"].include?(ask_with_timeout("generate `rspec:install`? (y or yes)").downcase.strip)

###### CAPISTRANO ######

if ["yes", "y"].include?(ask_with_timeout("Generate Capistrano? (y or yes)").downcase.strip)
`cap install`
prepend_file 'Capfile', "set :yes_array, ['y', 'yes', 'yeah', 'yep']\n"
gsub_file 'Capfile', 'require "capistrano/deploy"' do <<-TEXT
require "capistrano/deploy"

require 'capistrano/linked_files'

require 'capistrano/webpacker/precompile'

require 'capistrano/puma'
install_plugin Capistrano::Puma  # Default puma tasks
install_plugin Capistrano::Puma::Workers  # if you want to control the workers (in cluster mode)
# install_plugin Capistrano::Puma::Jungle # if you need the jungle tasks
# install_plugin Capistrano::Puma::Monit  # if you need the monit tasks
# install_plugin Capistrano::Puma::Nginx  # if you want to upload a nginx site template
TEXT
end
# require "capistrano/webpacker/precompile"
gsub_file 'Capfile', '# require "capistrano/rvm"', 'require "capistrano/rvm"'
gsub_file 'Capfile', '# require "capistrano/bundler"', 'require "capistrano/bundler"'
gsub_file 'Capfile', '# require "capistrano/rails/assets"', 'require "capistrano/rails/assets"'
# gsub_file 'Capfile', '# require "capistrano/webpacker/precompile"', 'require "capistrano/webpacker/precompile"'

gsub_file 'config/deploy.rb', 'set :application, "my_app_name"', "set :application, '#{app_name.downcase.strip}'"
gsub_file 'config/deploy.rb', 'set :repo_url, "git@example.com:me/my_repo.git"' do <<-TEXT
set :repo_url, "git@bitbucket.org:red-rocks/#{app_name.downcase.strip}.git"

set :use_sudo, false
set :bundle_flags, '--quiet'

set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, "#{`cat .ruby-version`.strip}@#{`cat .ruby-gemset`.strip}"

set :bundle_path, nil

# after 'deploy:updated', 'webpacker:precompile'
TEXT
end
inject_into_file 'config/deploy.rb', after: '# append :linked_files, "config/database.yml"' do <<-TEXT

set :linked_files,  [
  # "config/unicorn.god", "config/unicorn.rb",
  "public/robots.txt", "public/sitemap.xml.gz",
  "config/mongoid.yml", #"config/master.key",
  "config/database.yml",
  "config/credentials/production.key",
  "config/credentials/staging.key"
]

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :linked_dirs,  ["log",
                    "tmp/pids", "tmp/cache", "tmp/sc", "tmp/sockets", "tmp/god",
                    "public/system", "public/ckeditor_assets", "public/uploads",
                    "node_modules"]


set :skip_upload_files, ["public/sitemap.xml.gz"]
set :skip_upload_dirs,  ["log",
                          "tmp/pids", "tmp/cache", "tmp/sc", "tmp/sockets", "tmp/god",
                          "public/system", "public/uploads", "public/ckeditor_assets", "public/sitemaps", "public/favicons",
                          "node_modules"
]
TEXT
end
inject_into_file 'config/deploy.rb', after: '# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"' do <<-TEXT

set :linked_dirs,  ["log",
                    "tmp/pids", "tmp/cache", "tmp/sc", "tmp/sockets", "tmp/god",
                    "public/system", "public/ckeditor_assets", "public/uploads",
                    "node_modules"]
TEXT
end
remove_file 'config/deploy/staging.rb'
create_file 'config/deploy/staging.rb' do <<-TEXT
# require 'capistrano/rvm'

server '#{app_name.downcase.strip}.redrocks.pro', user: '#{app_name.downcase.strip}', roles: %w{app db web}

set :branch, :master
set :deploy_to, "/home/#{app_name.downcase.strip}/www/#{app_name.downcase.strip}/production"
set :format, :pretty
set :pty, true

set :keep_releases, 3

set :rails_env,       "production"

set :ssh_options, {forward_agent: true, non_interactive: false}
TEXT
end
remove_file 'config/deploy/production.rb'
create_file 'config/deploy/production.rb' do <<-TEXT
# require 'capistrano/rvm'

server '#{app_name.downcase.strip}.ru', user: '#{app_name.downcase.strip}', roles: %w{app db web}

set :branch, :master
set :deploy_to, "/home/#{app_name.downcase.strip}/www/#{app_name.downcase.strip}/production"
# set :deploy_to, "/home/#{app_name.downcase.strip}/www/#{app_name.downcase.strip}/staging"
set :format, :pretty
set :pty, true

set :keep_releases, 3

set :rails_env, "production"

set :ssh_options, {forward_agent: true, non_interactive: false}
TEXT
end
end

####### GIT #######

# remove_file '.gitignore'
inject_into_file '.gitignore', before: /^end/ do <<-TEXT

.idea
.idea/*

/dump/
/dump

# Ignore bundler config.
/.bundle

# Ignore all logfiles and tempfiles.
/log/*
/tmp/*
!/log/.keep
!/tmp/.keep

/public/assets
.byebug_history

#
# /config/unicorn.rb
# /config/unicorn.god
/config/master.key
# /log/*.log
# /tmp/
# /tmp/*
# /public/assets
# /public/assets/
# /public/assets/*
/public/system
# /public/system/
# /public/system/*
/public/uploads
# /public/uploads/
# /public/uploads/*
/public/ckeditor_assets
# /public/ckeditor_assets/
# /public/ckeditor_assets/*
/public/sitemap.xml.gz
/public/sitemap.xml
/public/robots.txt
/node_modules
TEXT
end

# create_file 'extra/.gitkeep', ''


if ["yes", "y"].include?(ask_with_timeout("Do u want init git? (y or yes)").downcase.strip)
git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }
end



    end

    def mongoid
      !!defined? Mongoid
    end

    def app_name
      Rails.application.class.parent_name
    end

  end
end
