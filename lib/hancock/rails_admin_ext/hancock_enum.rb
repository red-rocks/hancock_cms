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
            [{column: "#{abstract_model.table_name}.#{enum_method}" , type: :string}]
          end
          register_instance_option :queryable do
            true
          end

          register_instance_option :partial do
            :form_hancock_enum
          end

          register_instance_option :help do
            'Двойной клик перемещает между списками'
          end

        end
      end
    end
  end
end
