require 'rails_admin/config/fields/types/has_many_association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HancockMultisect < RailsAdmin::Config::Fields::Types::HasManyAssociation
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :partial do
            :form_hancock_multiselect
          end

          # orderable associated objects
          register_instance_option :orderable do
            false
          end

          register_instance_option :inline_add do
            false
          end

          register_instance_option :help do
            'Двойной клик перемещает между списками'
          end

          def nested_form
            false
          end

          def method_name
            "#{super.to_s.singularize}_ids".to_sym
          end

          # Reader for validation errors of the bound object
          def errors
            bindings[:object].errors[name]
          end
        end
      end
    end
  end
end
