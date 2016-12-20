module Hancock
  module Admin
    def self.map_config(is_active = false)
      Proc.new {
        active is_active
        label I18n.t('hancock.map')
        field :address, :string do
          searchable true
        end
        field :map_address, :string do
          searchable true
        end
        field :map_hint, :string do
          searchable true
        end
        field :coordinates, :string do
          searchable true
          read_only true
          formatted_value{ bindings[:object].coordinates.to_json }
        end
        field :lat do
          searchable true
        end
        field :lon do
          searchable true
        end

        if block_given?
          yield self
        end
      }
    end

    def self.url_block(is_active = false)
      Proc.new {
        active is_active
        label I18n.t('hancock.url')
        field :slugs, :hancock_slugs do
          searchable :_slugs
        end
        field :text_slug
      }
    end

    def self.content_block(is_active = false, options = {})
      if is_active.is_a?(Hash)
        is_active, fields = (is_active[:active] || false), is_active
      end

      _excluded_fields = options.delete(:excluded_fields) || []
      Proc.new {
        active is_active
        label I18n.t('hancock.content')
        unless _excluded_fields.include?(:excerpt)
          field :excerpt, :hancock_html do
            searchable :excerpt_html
          end
        end
        unless _excluded_fields.include?(:content)
          field :content, :hancock_html do
            searchable :content_html
          end
        end
      }
    end

  end
end
