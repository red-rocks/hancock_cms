module Hancock
  module Admin
    def self.map_config(is_active = false, options = {})
      if is_active.is_a?(Hash)
        is_active, options = (is_active[:active] || false), is_active
      end

      Proc.new {
        active is_active
        label options[:label] || I18n.t('hancock.map')
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

        Hancock::RailsAdminGroupPatch::hancock_cms_group(self, options[:fields] || {})

        if block_given?
          yield self
        end
      }
    end

    def self.url_block(is_active = false, options = {})
      if is_active.is_a?(Hash)
        is_active, options = (is_active[:active] || false), is_active
      end

      Proc.new {
        active is_active
        label options[:label] || I18n.t('hancock.url')
        field :slugs, :hancock_slugs
        field :text_slug

        Hancock::RailsAdminGroupPatch::hancock_cms_group(self, options[:fields] || {})

        if block_given?
          yield self
        end
      }
    end

    def self.content_block(is_active = false, options = {})
      if is_active.is_a?(Hash)
        is_active, options = (is_active[:active] || false), is_active
      end

      _excluded_fields = [options.delete(:excluded_fields) || []].flatten
      Proc.new {
        active is_active
        label options[:label] || I18n.t('hancock.content')
        ([:excerpt, :content] - _excluded_fields).each do |f|
          field f, :hancock_html
        end
        # unless _excluded_fields.include?(:excerpt)
        #   field :excerpt, :hancock_html
        # end
        # unless _excluded_fields.include?(:content)
        #   field :content, :hancock_html
        # end

        Hancock::RailsAdminGroupPatch::hancock_cms_group(self, options[:fields] || {})

        if block_given?
          yield self
        end
      }
    end

    def self.categories_block(is_active = false, options = {})
      if is_active.is_a?(Hash)
        is_active, options = (is_active[:active] || false), is_active
      end

      _excluded_fields = [options.delete(:excluded_fields) || []].flatten
      Proc.new {
        active is_active
        label options[:label] || I18n.t('hancock.categories')
        field :main_category do
          inline_add false
          inline_edit false
        end unless _excluded_fields.include?(:main_category)
        field :categories, :hancock_multiselect unless _excluded_fields.include?(:categories)

        Hancock::RailsAdminGroupPatch::hancock_cms_group(self, options[:fields] || {})

        if block_given?
          yield self
        end
      }
    end

  end
end
