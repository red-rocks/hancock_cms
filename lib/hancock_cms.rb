unless defined?(Hancock) && Hancock.respond_to?(:orm) && [:active_record, :mongoid].include?(Hancock.orm)
  puts "please use hancock_cms_mongoid or hancock_cms_activerecord and not hancock directly"
  exit 1
end

require 'hancock/version'
require 'hancock/plugin'
require 'hancock/plugin_configuration'
require 'hancock/configuration'
require 'devise'
require 'hancock/routes'

require 'simple_form'
require 'hancock/simple_form_patch'

require 'geocoder'

require 'filename_to_slug'

require 'codemirror-rails'


require 'rails_admin'
require 'hancock/rails_admin_ext/config'

require 'hancock/rails_admin_ext/hancock_enum'
require 'hancock/rails_admin_ext/hancock_enum_with_custom'
require 'hancock/rails_admin_ext/hancock_array'
require 'hancock/rails_admin_ext/hancock_hash'
require 'hancock/rails_admin_ext/hancock_html'
require 'hancock/rails_admin_ext/hancock_slugs'
require 'hancock/rails_admin_ext/hancock_multiselect'

require 'hancock/rails_admin_ext/patches/navigation_patch'
require 'hancock/rails_admin_ext/patches/field_patch'
require 'hancock/rails_admin_ext/patches/fieldset_patch'
require 'hancock/rails_admin_ext/patches/new_controller_patch'
require 'hancock/rails_admin_ext/patches/group_patch'
require 'hancock/rails_admin_ext/patches/hancock_cms_group'
require 'hancock/rails_admin_ext/patches/has_fields'


require 'rails_admin_nested_set'
require 'rails_admin_toggleable'

require 'ack_rails_admin_settings'
require 'hancock/rails_admin_settings_patch'

require 'ckeditor'

require 'kaminari/actionview'

require 'stickykit/rails'

require 'hancock/model'
require 'hancock/engine'
require 'hancock/controller'


module Hancock

  MODELS = []
  PLUGINS = []

  include Hancock::Plugin

  class << self

    def rails4?
      false
    end

    def rails5?
      true
    end


    def register_model(model)
      Hancock::MODELS << model unless Hancock::MODELS.include?(model)
    end
    def register_plugin(plugin)
      Hancock::PLUGINS << plugin unless Hancock::PLUGINS.include?(plugin)
    end

    def clear_history_from_empty_objects
      ::HistoryTracker.all.map do |h|
        begin
          begin
            h.delete if h.trackable.nil?
          rescue
            h.delete
          end
        rescue
        end
      end if defined?(::HistoryTracker)
    end

    def clear_history!
      ::HistoryTracker.delete_all if defined?(::HistoryTracker)
    end

  end

  autoload :Migration, 'hancock/migration'

  autoload :Admin,  'hancock/admin'
  module Admin
    autoload :EmbeddedElement,      'hancock/admin/embedded_element'
  end

  module Models
    autoload :EmbeddedElement,      'hancock/models/embedded_element'

    module Mongoid
      autoload :EmbeddedElement,      'hancock/models/mongoid/embedded_element'
    end

    module ActiveRecord
    end
  end

  module Controllers
  end
end

require 'manual_slug'

require 'scrollbar-rails'
