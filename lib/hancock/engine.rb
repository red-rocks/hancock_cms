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
      ::RailsAdmin::ApplicationHelper.send :include, Hancock::RailsAdminApplicationHelperNavigationPatch
    end

    initializer "RailsAdminPatch (Fieldset)" do
      ::RailsAdmin::FormBuilder.send :include, Hancock::RailsAdminFormBuilderFieldsetPatch
    end
    # initializer 'hancock_cms.paperclip' do
    #   # require 'paperclip/style'
    #   # module ::Paperclip
    #   #   class Style
    #   #     alias_method :processor_options_without_auto_orient, :processor_options
    #   #     def processor_options
    #   #       processor_options_without_auto_orient.merge(auto_orient: false)
    #   #     end
    #   #   end
    #   # end
    # end

    # initializer "hancock_cms.email_defaults" do
    #   # Write default email settings to DB so they can be changed.
    #
    #   #temp
    #   begin
    #     if Settings and Settings.table_exists?
    #   #     Settings.default_email_from(default: 'noreply@site.domain')
    #   #     Settings.form_email(default: 'admin@site.domain')
    #   #     Settings.email_topic(default: 'с сайта')
    #       Settings.logo_image(kind: :image) if Settings.file_uploads_supported and !RailsAdminSettings::Setting.ns("main").where(key: "logo_image").exists?
    #     end
    #   rescue
    #   end
    # end

    # initializer 'hancock_cms.paperclip' do
    #   # require 'paperclip/style'
    #   # module ::Paperclip
    #   #   class Style
    #   #     alias_method :processor_options_without_auto_orient, :processor_options
    #   #     def processor_options
    #   #       processor_options_without_auto_orient.merge(auto_orient: false)
    #   #     end
    #   #   end
    #   # end
    # end

    config.after_initialize do
      # trigger autoload so models are registered in Mongoid::Elasticearch
      # Hancock.config.search_models.map(&:constantize)

      # Write default email settings to DB so they can be changed.
      begin
        if Settings and Settings.table_exists?
          # Settings.default_email_from(default: 'noreply@site.domain')
          # Settings.form_email(default: 'admin@site.domain')
          # Settings.email_topic(default: 'с сайта')
          Settings.logo_image(kind: :image) if Settings.file_uploads_supported and !RailsAdminSettings::Setting.ns("main").where(key: "logo_image").exists?
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
