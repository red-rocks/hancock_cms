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
          if Settings.file_uploads_supported
            if !RailsAdminSettings::Setting.ns("main").where(key: "logo_image").exists?
              Settings.logo_image(kind: :image)
            end
          end
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
