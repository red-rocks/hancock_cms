require 'rails_admin/config/fields/types/text'
require 'json'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HancockHash < RailsAdmin::Config::Fields::Types::Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)
          include RailsAdmin::Engine.routes.url_helpers

          register_instance_option :editor_type do
            :default
          end

          register_instance_option :string_method do
            "#{name}_str"
          end

          register_instance_option :hash_method do
            case editor_type
            when :default, :standard, :main, :text, :text_area, :textarea, :string
              "#{name}_hash"
            else
              name
            end
          end

          register_instance_option :value do
            formatted_value
          end

          register_instance_option :tabbed do
            true
          end

          register_instance_option :searchable do
            string_method.to_s
          end
          register_instance_option :queryable do
            true
          end



          register_instance_option :element_partial do
            "rails_admin/main/hancock_hash/#{partial_name}".freeze if partial_name
          end

          register_instance_option :partial_name do
            case editor_type.to_sym
            when :default, :standard, :main, :text, :text_area, :textarea, :string
              nil
            when :fixed_keys
              'fixed_keys'.freeze
            when :full
              'full'.freeze
            end

          end

          register_instance_option :empty_element_value do
            ''.freeze
          end


          ############ localize ######################
          register_instance_option :translations_field do
            case editor_type
            when :default, :standard, :main, :text, :text_area, :textarea, :string
              (string_method.to_s + '_translations').to_sym
            else
              (name.to_s + '_translations').to_sym
            end

          end

          register_instance_option :localized? do
            @abstract_model.model.public_instance_methods.include?(translations_field)
          end

          register_instance_option :pretty_value do
            if localized?
              I18n.available_locales.map { |l|
                ret = nil
                I18n.with_locale(l) do
                  _hash = bindings[:object].send(hash_method) || {}
                  ret = ("#{l}:<pre>" + JSON.pretty_generate(_hash) + "</pre>")
                end
                ret
              }.join.html_safe
            else
              _hash = bindings[:object].send(hash_method) || {}
              ("<pre>" + JSON.pretty_generate(_hash) + "</pre>").html_safe
            end
          end

          register_instance_option :formatted_value do
            if localized?
              _val = bindings[:object].send((hash_method.to_s + '_translations').to_sym)

              case editor_type
              when :default, :standard, :main, :text, :text_area, :textarea, :string
                _val.each_pair { |l, _hash|
                  begin
                    _val[l] = JSON.pretty_generate(_hash)
                  rescue
                  end
                }
              else
                _val
              end


            else
              case editor_type
              when :default, :standard, :main, :text, :text_area, :textarea, :string
                begin
                  JSON.pretty_generate(bindings[:object].send hash_method)
                rescue
                  bindings[:object].send hash_method
                end
              else
                bindings[:object].send hash_method
              end
            end
          end

          register_instance_option :allowed_methods do
            case editor_type
            when :default, :standard, :main, :text, :text_area, :textarea, :string
              localized? ? [string_method, translations_field] : [string_method]
            else
              localized? ? [hash_method, translations_field] : [hash_method]
            end

          end

          register_instance_option :partial do
            localized? ? :hancock_hash_ml : :hancock_hash
          end
        end
      end
    end
  end
end
