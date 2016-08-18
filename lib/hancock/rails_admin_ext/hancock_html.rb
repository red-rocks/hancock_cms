require 'rails_admin/config/fields/types/ck_editor'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HancockHtml < RailsAdmin::Config::Fields::Types::CKEditor
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)
          include RailsAdmin::Engine.routes.url_helpers

          register_instance_option :html_method do
            "#{name}_html".to_sym
          end

          register_instance_option :clear_method do
            "#{name}_clear".to_sym
          end

          register_instance_option :pretty_value do
            bindings[:object].send(html_method)
          end

          register_instance_option :formatted_value do
            pretty_value
          end

          register_instance_option :export_value do
            pretty_value
          end

          register_instance_option :boolean_view_helper do
            :check_box
          end

          register_instance_option :tabbed do
            true
          end


          ############ localize ######################
          register_instance_option :html_translations_field do
            (html_method.to_s + '_translations').to_sym
          end
          register_instance_option :clear_translations_field do
            (clear_method.to_s + '_translations').to_sym
          end

          register_instance_option :form_value do
            if localized?
              {
                html: bindings[:object].send(html_translations_field),
                clear: bindings[:object].send(clear_translations_field)
              }
            else
              {
                html: bindings[:object].send(html_method),
                clear: bindings[:object].send(clear_method)
              }
            end
          end

          register_instance_option :localized? do
            @abstract_model.model_name.constantize.public_instance_methods.include?(html_translations_field) and
              @abstract_model.model_name.constantize.public_instance_methods.include?(clear_translations_field)
          end

          register_instance_option :allowed_methods do
            localized? ? [html_method, clear_method, html_translations_field, clear_translations_field] : [html_method, clear_method]
          end

          register_instance_option :partial do
            localized? ? :hancock_html_ml : :hancock_html
          end
        end
      end
    end
  end
end
