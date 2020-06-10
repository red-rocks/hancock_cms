require 'rails_admin/config/fields/types/ck_editor'

is_medium_editor = !!defined?(RailsAdminMediumEditor)
parent_field = (is_medium_editor ? RailsAdmin::Config::Fields::Types::MediumEditor : RailsAdmin::Config::Fields::Types::CKEditor)

class RailsAdmin::Config::Fields::Types::HancockHtml < parent_field
  # Register field type for the type loader
  RailsAdmin::Config::Fields::Types::register(self)
  include RailsAdmin::Engine.routes.url_helpers

  register_instance_option :is_medium_editor do
    !!(defined?(RailsAdmin::Config::Fields::Types::MediumEditor) and (self.class.superclass == RailsAdmin::Config::Fields::Types::MediumEditor))
  end

  register_instance_option :html_method do
    "#{name}_html".to_sym
  end

  register_instance_option :searchable do
    html_method.to_s
  end
  register_instance_option :queryable do
    true
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

  register_instance_option :help do
    if @abstract_model.model.respond_to?(:insertions_fields)
      if @abstract_model.model.insertions_fields.include?(name)
        'Можно использовать вставки'
      end
    end
  end


  ############ localize ######################
  register_instance_option :html_translations_field do
    (html_method.to_s + '_translations').to_sym
  end
  register_instance_option :clear_translations_field do
    (clear_method.to_s + '_translations').to_sym
  end

  # register_instance_option :form_value do
  register_instance_option :value do
    form_value
  end
  def form_value
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
    (@abstract_model&.model&.fields[html_method.to_s]&.options || {})[:localize] &&
      (@abstract_model&.model&.fields[clear_method.to_s]&.options || {})[:localize]
  end

  register_instance_option :allowed_methods do
    localized? ? [html_method, clear_method, html_translations_field, clear_translations_field] : [html_method, clear_method]
  end

  register_instance_option :partial do
    # localized? ? :hancock_html_ml : :hancock_html
    if is_medium_editor
      localized? ? "form_medium_editor_ml" : "form_medium_editor"
    else
      localized? ? "hancock/html_ml" : "hancock/html"
    end
  end
  
end
