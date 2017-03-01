require_relative 'hancock_enum'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HancockEnumWithCustom < RailsAdmin::Config::Fields::Types::HancockEnum
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)
          register_instance_option :help do
            'Выберите из списка или введите свой вариант'
          end

          register_instance_option :enum do
            []
          end

          register_instance_option :selection do
            ([enum] + [form_value]).flatten.uniq
          end

          register_instance_option :partial do
            :form_hancock_enum_with_custom
          end

        end
      end
    end
  end
end
