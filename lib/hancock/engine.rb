module Hancock
  class Engine < ::Rails::Engine
    # isolate_namespace Hancock

    # rake_tasks do
    #   require File.expand_path('../tasks', __FILE__)
    # end


    initializer "RailsAdminSettingsPatch (CMS)" do
      ::RailsAdminSettings::Setting.send(:include, Hancock::RailsAdminSettingsPatch)
    end


    config.to_prepare do
      require 'rails_admin/hancock/form_builder'

      ::RailsAdmin::MainController.send(:include, ::RailsAdmin::Application::HancockHelper)
      ::RailsAdmin::MainController.send(:include, ::RailsAdmin::Main::HancockHelper)
      # ::RailsAdmin::ApplicationHelper.send(:include, ::RailsAdmin::Hancock::FormBuilder)

      ::RailsAdmin::ApplicationController.send(:helper, ::RailsAdmin::Application::HancockHelper)
      ::RailsAdmin::ApplicationController.send(:helper, ::RailsAdmin::Main::HancockHelper)
    end

    config.after_initialize do

      begin
        if Settings and Settings.table_exists?
          settings_scope = Settings
          ns = settings_scope.ns.name
          admin_ns = 'admin'
          admin_settings_scope = Settings.ns(admin_ns)

          if Settings.file_uploads_supported
            if !RailsAdminSettings::Setting.ns(ns).where(key: "logo_image").exists?
              settings_scope.logo_image(kind: :image)
            end
          end

          helpers_whitelist_default = {}
          if !(_helpers_whitelist = admin_settings_scope.getnc('helpers_whitelist')).nil?
            if _helpers_whitelist.kind != :hash
              helpers_whitelist_default = JSON.parse(_helpers_whitelist.val) rescue YAML.load(_helpers_whitelist.val) rescue {}
              _helpers_whitelist.remove
            end
          end
          admin_settings_scope.helpers_whitelist(default: helpers_whitelist_default, kind: :hash)


          helpers_blacklist_default = []
          if !(_helpers_blacklist = admin_settings_scope.getnc('helpers_blacklist')).nil?
            if _helpers_blacklist.kind != :array
              helpers_blacklist_default = JSON.parse(_helpers_whitelist.val) rescue YAML.load(_helpers_whitelist.val) rescue []
              _helpers_blacklist.remove
            end
          end
          admin_settings_scope.helpers_blacklist(default: helpers_blacklist_default, kind: :array)
          # unless Settings.ns('admin').exists?("helpers_whitelist")
          #   Settings.ns('admin').helpers_whitelist(default: '', kind: :text, label: 'Белый список хелперов')
          # end
          # unless Settings.ns('admin').exists?("helpers_human_names")
          #   Settings.ns('admin').helpers_human_names(default: '', kind: :yaml, label: 'Имена хелперов')
          # end

        end
      rescue
      end

      # clear empty history for prevent admin panel crashs
      begin
        ::Hancock.clear_history_from_empty_objects
      rescue
      end

    end

  end
end
