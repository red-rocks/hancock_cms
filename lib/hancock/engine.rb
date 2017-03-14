module Hancock
  class Engine < ::Rails::Engine
    # isolate_namespace Hancock

    # rake_tasks do
    #   require File.expand_path('../tasks', __FILE__)
    # end


    initializer "RailsAdminSettingsPatch (CMS)" do
      ::RailsAdminSettings::Setting.send(:include, Hancock::RailsAdminSettingsPatch)
    end


    initializer "RailsAdminPatch (Navigation)" do
      # ::RailsAdmin::ApplicationHelper.send :include, Hancock::RailsAdminApplicationHelperNavigationPatch
      # ::RailsAdmin::ApplicationHelper.module_eval "include Hancock::RailsAdminApplicationHelperNavigationPatch"
      # Hancock::RailsAdminApplicationHelperNavigationPatch.patch
    end


    initializer "RailsAdminPatch (Fieldset)" do
      # ::RailsAdmin::FormBuilder.send :include, Hancock::RailsAdminFormBuilderFieldsetPatch

      # Hancock::RailsAdminFormBuilderFieldsetPatch.patch
    end


    initializer "RailsAdminPatch (MainNavigation)" do
      # ::RailsAdmin::ApplicationHelper.send :include, Hancock::RailsAdminMainNavigationPatch
      # ::RailsAdmin::ApplicationHelper.module_eval "include Hancock::RailsAdminMainNavigationPatch"
      # Hancock::RailsAdminMainNavigationPatch.patch
    end



    config.to_prepare do
      # ::RailsAdmin::ApplicationHelper.module_eval "include Hancock::RailsAdminApplicationHelperNavigationPatch"
      # #
      # ::RailsAdmin::ApplicationHelper.module_eval "include Hancock::RailsAdminMainNavigationPatch"

      # Hancock::RailsAdminApplicationHelperNavigationPatch.patch
      # Hancock::RailsAdminMainNavigationPatch.patch
      #
      # Hancock::RailsAdminFormBuilderFieldsetPatch.patch

      # require 'rails_admin/application/hancock_helper'
      # require 'rails_admin/main/hancock_helper'
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
