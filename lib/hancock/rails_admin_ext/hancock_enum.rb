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

          # register_instance_option :partial do
          #   # :form_hancock_enum
          #   "hancock/form_enum"
          # end

          register_instance_option :translations_field do
            # (name.to_s + '_translations').to_sym
            :"#{name}_translations"
          end

          register_instance_option :value do
            form_value
          end
          def form_value
            if localized?
              bindings[:object].send(translations_field)
            else
              bindings[:object].send(name)
            end
          end

          register_instance_option :localized? do
            # puts 'register_instance_option :localized do' 
            # puts @abstract_model.model.public_instance_methods.include?(translations_field)
            # puts translations_field
            @abstract_model.model.public_instance_methods.include?(translations_field)
          end

          register_instance_option :tabbed do
            true
          end

          register_instance_option :allowed_methods do
            localized? ? [name, translations_field] : [name]
          end



          register_instance_option :partial do
            # localized? ? :hancock_hash_ml : :hancock_hash
            localized? ? "hancock/form_enum_ml" : "hancock/form_enum"
            # "rails_admin/main/" + (localized? ? "hancock/form_enum_ml" : "hancock/form_enum")
          end

          register_instance_option :help do
            'Двойной клик перемещает между списками' if multiple
          end

        end
      end
    end
  end
end
