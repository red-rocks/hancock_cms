require 'rails_admin/config/fields/types/enum'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HancockEnum < RailsAdmin::Config::Fields::Types::Enum
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :searchable do
            true
          end
          register_instance_option :searchable_columns do
            if enum_method
              [{column: "#{abstract_model.table_name}.#{enum_method}" , type: :string}]
            else
              []
            end
          end
          register_instance_option :queryable do
            true
          end

          register_instance_option :enum_method do
            if bindings and (_obj = bindings[:object])
              _class = _obj.class
              @enum_method ||= _class.respond_to?("#{name}_enum") || _obj.respond_to?("#{name}_enum") ? "#{name}_enum" : name
            end
          end

          register_instance_option :partial do
            :form_hancock_enum
          end

          register_instance_option :help do
            'Двойной клик перемещает между списками' if multiple
          end

        end
      end
    end
  end
end
