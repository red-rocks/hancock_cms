require 'rails/generators'
# require "rails/generators/rails/app/app_generator"

module Hancock::Cms
  class SetupGenerator < Rails::Generators::Base

    desc 'Hancock CMS Carcass generator'
    def install

####### DEVISE #######

generate "devise:install"
gsub_file 'config/initializers/devise.rb', "'please-change-me-at-config-initializers-devise@example.com'", "'noreply@#{app_name.dasherize.downcase}.ru'"
inject_into_file 'config/initializers/devise.rb', after: /^end/ do <<-TEXT

Rails.application.config.to_prepare do
  Devise::SessionsController.layout       "hancock/devise/sessions"
  Devise::RegistrationsController.layout  "hancock/devise/registrations"
  Devise::ConfirmationsController.layout  "hancock/devise/confirmations"
  Devise::UnlocksController.layout        "hancock/devise/unlocks"
  Devise::PasswordsController.layout      "hancock/devise/passwords"
end
TEXT
end

generate "devise", "User"
####### ROUTES #######

remove_file 'config/routes.rb'
create_file 'config/routes.rb' do <<-TEXT
Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'hancock/sessions'}

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  hancock_cms_routes
end
TEXT
end


####### INITIALIZERS #######

inject_into_file 'config/initializers/assets.rb', before: /\z/ do <<-TEXT
Rails.application.config.assets.precompile += %w( *.svg )
Rails.application.config.assets.precompile += %w( ckeditor/* )
Rails.application.config.assets.precompile += %w( codemirror.js codemirror.css codemirror/**/* )
TEXT
end

if mongoid
  generate "ckeditor:install", "--orm=mongoid", "--backend=paperclip"
else
  generate "ckeditor:install", "--orm=active_record", "--backend=paperclip"
end
gsub_file 'config/initializers/ckeditor.rb', "# config.image_file_types = %w(jpg jpeg png gif tiff)", "config.image_file_types = %w(jpg jpeg png gif tiff svg)"
gsub_file 'config/initializers/ckeditor.rb', "# config.authorize_with :cancan",                       "config.authorize_with :cancancan"
gsub_file 'config/initializers/ckeditor.rb', "# config.assets_languages = ['en', 'uk']",              "config.assets_languages = ['en', 'ru']"

if mongoid
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

# generate 'paperclip_optimizer:install'
# remove_file 'config/initializers/paperclip_optimizer.rb'
# generate "hancock:cms:paperclip_optimizer"

# generate 'rails_email_preview:install'
# remove_file 'app/mailer_previews/contact_mailer_preview.rb'
# create_file 'app/mailer_previews/contact_mailer_preview.rb' do <<-TEXT
# class ContactMailerPreview
#   def new_message_email
#     Hancock::Feedback::ContactMailer.new_message_email(Hancock::Feedback::ContactMessage.all.to_a.sample)
#   end
# end
# TEXT
# end

generate "hancock:cms:config"

generate "hancock:cms:rack"

generate "hancock:cms:admin"

remove_file 'config/initializers/session_store.rb'
if mongoid
create_file 'config/initializers/session_store.rb' do  <<-TEXT
# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_#{app_name.tableize.singularize}_session'
Rails.application.config.session_store :mongoid_store
TEXT
end
else
generate 'active_record_store:session_migration'
create_file 'config/initializers/session_store.rb' do  <<-TEXT
# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_#{app_name.tableize.singularize}_session'
Rails.application.config.session_store :active_record_store
TEXT
end
end

# unless mongoid
#   generate 'simple_captcha'
# end

generate "simple_form:install"


####### CONTROLLERS #######

remove_file 'app/controllers/application_controller.rb'
create_file 'app/controllers/application_controller.rb' do <<-TEXT
class ApplicationController < ActionController::Base
  include Hancock::Controller
end
TEXT
end


####### MODELS #######

generate "hancock:cms:ability"

gsub_file 'app/models/user.rb', '# :confirmable, :lockable, :timeoutable and :omniauthable' do <<-TEXT
include Hancock::Model
  include Hancock::Enableable
  include Hancock::RailsAdminPatch
  def self.manager_can_default_actions
    [:show, :read]
  end
  def manager_cannot_actions
    [:new, :create, :delete, :destroy]
  end

  cattr_accessor :current_user

  # Include default devise modules. Others available are:
  # :confirmable,  :lockable, :timeoutable and :omniauthable
TEXT
end

gsub_file 'app/models/user.rb', ':registerable,', ' :lockable,'
if mongoid
gsub_file 'app/models/user.rb', '# field :failed_attempts', 'field :failed_attempts'
gsub_file 'app/models/user.rb', '# field :unlock_token', 'field :unlock_token'
gsub_file 'app/models/user.rb', '# field :locked_at', 'field :locked_at'

inject_into_file 'app/models/user.rb', before: /^end/ do <<-TEXT

  field :name,    type: String
  field :login,   type: String
  field :roles,   type: Array, default: []

  before_save do
    self.roles ||= []
    self.roles.reject! { |r| r.blank? }
  end

  AVAILABLE_ROLES = ["admin", "manager", "client"]

  AVAILABLE_ROLES.each do |r|
    class_eval <<-EVAL
      def \#{r}?
        self.roles and self.roles.include?("\#{r}")
      end

      scope :\#{r.pluralize}, -> { any_in(roles: "\#{r}") }
    EVAL
  end

  def self.generate_first_admin_user
    if ::User.admins.all.count == 0
      _email_pass = 'admin@#{app_name.dasherize.downcase}.ru'
      if ::User.new(roles: ["admin"], email: _email_pass, password: _email_pass, password_confirmation: _email_pass).save
        puts "AdminUser with email and password '\#{_email_pass}' was created!"
      else
        puts 'Creating AdminUser error'
      end
    else
      puts 'AdminUsers are here already'
    end
  end

  def self.generate_first_manager_user
    if ::User.managers.all.count == 0
      _email_pass = 'manager@#{app_name.dasherize.downcase}.ru'
      if ::User.create(roles: ["manager"], email: _email_pass, password: _email_pass, password_confirmation: _email_pass)
        puts "ManagerUser with email and password '\#{_email_pass}' was created!"
      else
        puts 'Creating ManagerUser error'
      end
    else
      puts 'ManagerUsers are here already'
    end
  end

  rails_admin do
    list do
      field :email
      field :name
      field :login
      field :roles do
        pretty_value do
          render_object = (bindings[:controller] || bindings[:view])
          render_object.content_tag(:p, bindings[:object].roles.join(", ")) if render_object
        end
      end
    end

    edit do
      group :login do
        active false
        field :email, :string do
          visible do
            render_object = (bindings[:controller] || bindings[:view])
            render_object and (render_object.current_user.admin? or (render_object.current_user.manager? and render_object.current_user == bindings[:object]))
          end
        end
        field :name, :string
        field :login, :string do
          visible do
            render_object = (bindings[:controller] || bindings[:view])
            render_object and render_object.current_user.admin?
          end
        end
      end

      group :roles do
        active false
        field :roles, :enum do
          enum do
            AVAILABLE_ROLES
          end

          multiple do
            true
          end

          visible do
            render_object = (bindings[:controller] || bindings[:view])
            render_object and render_object.current_user.admin?
          end
        end
      end

      group :password do
        active false
        field :password do
          visible do
            render_object = (bindings[:controller] || bindings[:view])
            render_object and (render_object.current_user.admin? or render_object.current_user == bindings[:object])
          end
        end
        field :password_confirmation do
          visible do
            render_object = (bindings[:controller] || bindings[:view])
            render_object and (render_object.current_user.admin? or render_object.current_user == bindings[:object])
          end
        end
      end
    end

  end
TEXT
end
end


###### HANCOCK OTHERS ######

unless mongoid
  generate "hancock:cms:migration"
  generate "rails_admin_settings:migration"
end

remove_file 'app/views/layouts/application.html.erb'
generate "hancock:cms:layout"

unless mongoid
  rake "db:migrate"
end

run 'rails r "User.generate_first_admin_user"'

remove_file 'app/assets/stylesheets/application.css'
remove_file 'app/assets/javascripts/application.js'
generate "hancock:cms:assets", app_name

remove_file 'public/robots.txt'
generate "hancock:cms:robots", app_name

#god+unicorn
generate "hancock:cms:unicorn_god", app_name
#scripts
generate "hancock:cms:scripts", app_name

FileUtils.cp(Pathname.new(destination_root).join('config', 'secrets.yml').to_s, Pathname.new(destination_root).join('config', 'secrets.yml.example').to_s)

unless mongoid
  generate "paper_trail:install"
  generate "friendly_id"
  rake "db:migrate"
end

generate "rspec:install"


####### GIT #######

remove_file '.gitignore'
create_file '.gitignore' do <<-TEXT
# See https://help.github.com/articles/ignoring-files for more about ignoring files.
#
# If you find yourself ignoring temporary files generated by your text editor
# or operating system, you probably want to add a global ignore instead:
#   git config --global core.excludesfile '~/.gitignore_global'
.idea
.idea/*

/.bundle
/log/*.log
/tmp/*
/public/assets
/public/ckeditor_assets
Gemfile.lock
TEXT
end

create_file 'extra/.gitkeep', ''

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

    end

    def mongoid
      defined? Mongoid
    end

    def app_name
      Rails.application.class.parent_name
    end

  end
end
