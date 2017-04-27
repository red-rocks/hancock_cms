require 'hancock/rails_admin_ext/hancock_enum_with_custom'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HancockArray < RailsAdmin::Config::Fields::Types::HancockEnumWithCustom
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :partial do
            enum.blank? ? :hancock_array : :form_hancock_enum_with_custom
          end

          register_instance_option :multiple do
            true
          end

        end
      end
    end
  end
end
