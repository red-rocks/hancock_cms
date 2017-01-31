module Hancock::UserDefined
  extend ActiveSupport::Concern

  included do
    include Hancock::Insertions

    class_attribute :user_defined_fields
    self.user_defined_fields ||= {}
    def user_defined_fields
      self.class.user_defined_fields
    end
  end

  class_methods do
    def user_defined_field(name, opts = {type: String, default: ''})
      field name, opts
      user_defined_for name, opts
    end
    def user_defined_for(name, opts = {})
      return if name.blank?
      name = name.to_sym
      return if user_defined_fields.keys.include?(name)
      _method_name = opts[:as].present? ? opts[:as] : "user_defined_#{name}"
      _render_method_name = "render_#{_method_name}"
      _advanced_render_method =  "#{_render_method_name}_or"#"render_#{name}"
      field _render_method_name, type: Boolean, default: false
      insertions_for name, opts[:insertions_options] || {}
      user_defined_fields[name] = {
        method: _method_name,
        render_method: _render_method_name,
        advanced_render_method: _advanced_render_method,
        options: opts
      }
      if _method_name
        class_eval <<-EVAL
          def #{_method_name}
            page_#{name}.html_safe
          end
          def #{_advanced_render_method}(&block)
            if #{_render_method_name}
              #{_method_name}.html_safe
            else
              yield if block_given?
              nil
            end
          end
        EVAL
      end
      name
    end


  end
end
