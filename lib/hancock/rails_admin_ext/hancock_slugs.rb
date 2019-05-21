require 'hancock/rails_admin_ext/hancock_enum'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HancockSlugs < RailsAdmin::Config::Fields::Types::HancockEnum
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option :allowed_methods do
            unless localized? 
              ret = [name] 
            else
              ret = [name, translations_field] 
              # VERY hardfix
              ret << "_#{translations_field}".to_sym unless translations_field.to_s.starts_with?("_slugs_")
              ret << translations_field.to_s.sub("_", "").to_sym if translations_field.to_s.starts_with?("_slugs_")
            end
            ret.uniq
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
