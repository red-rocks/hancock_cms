require 'rails_admin/config/fields/types/enum'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HancockSlugs < RailsAdmin::Config::Fields::Types::Enum
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option :searchable do
            true
          end

          register_instance_option :enum_method do
            :slugs
          end

          register_instance_option :visible do
            bindings[:view].current_user.admin?
          end

          register_instance_option :multiple do
            true
          end

          register_instance_option :pretty_value do
            value.join("<br>").html_safe if value
          end

        end
      end
    end
  end
end
