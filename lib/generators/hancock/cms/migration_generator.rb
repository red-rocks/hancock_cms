require 'rails/generators'
require 'rails/generators/active_record'

module Hancock::Cms
  class MigrationGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    desc 'Hancock::Cms migration generator'
    def install
      migration_template "migrations/rails_admin_settings_hancock_patch.rb", "db/migrate/rails_admin_settings_hancock_patch.rb"
    end
  end
end
