if Hancock.mongoid?
  module Hancock::HtmlField
    extend ActiveSupport::Concern

    module ClassMethods
      def hancock_cms_html_field(name, opts = {})
        clear_by_default = opts.delete(:clear_by_default)
        clear_by_default = false unless clear_by_default == true

        _html_field_name = "#{name}_html".freeze

        field _html_field_name, opts
        field "#{name}_clear", type: Boolean, default: clear_by_default, localize: opts[:localize]

        insertions_for(name) if respond_to?(:insertions_for)

        class_eval <<-EVAL
          def #{name}
            self.#{_html_field_name} ||= ""
            return self.#{_html_field_name} unless self.#{name}_clear
            clean_#{name}
          end
          def #{name}=(val)
            self.#{_html_field_name} = val
          end

          def clean_#{name}
            self.#{_html_field_name} ||= ""
            Rails::Html::FullSanitizer.new.sanitize(self.#{_html_field_name}.strip)
          end
        EVAL
      end
    end
  end
end
