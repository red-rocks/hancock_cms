module Hancock
  module Admin
    def self.map_config(is_active = false)
      Proc.new {
        active is_active
        label I18n.t('hancock.map')
        field :address, :string
        field :map_address, :string
        field :map_hint, :string
        field :coordinates, :string do
          read_only true
          formatted_value{ bindings[:object].coordinates.to_json }
        end
        field :lat
        field :lon

        if block_given?
          yield self
        end
      }
    end

    def self.url_block(is_active = false)
      Proc.new {
        active is_active
        label I18n.t('hancock.url')
        field :slugs, :hancock_slugs
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
        field :excerpt, :hancock_html unless _excluded_fields.include?(:excerpt)
        field :content, :hancock_html unless _excluded_fields.include?(:content)
      }
    end

  end
end
