module Hancock
  module Admin
    def self.map_config(is_active = false, options = {})
      if is_active.is_a?(Hash)
        is_active, options = (is_active[:active] || false), is_active
      end
      fields = (options[:fields] ||= {})
      field_names = [:address, :map_address, :map_hint, :coordinates, :lat, :lon]
      field_showings = get_field_showings(fields, field_names)

      Proc.new {
        active is_active
        label options[:label] || I18n.t('hancock.map')

        field :address, :string do
          searchable true
        end if field_showings[:address]

        field :map_address, :string do
          searchable true
        end if field_showings[:map_address]

        field :map_hint, :string do
          searchable true
        end if field_showings[:map_hint]

        field :coordinates, :string do
          searchable true
          read_only true
          formatted_value{ bindings[:object].coordinates.to_json }
        end if field_showings[:coordinates]

        field :lat do
          searchable true
        end if field_showings[:lat]

        field :lon do
          searchable true
        end if field_showings[:lon]

        Hancock::RailsAdminGroupPatch::hancock_cms_group(self, options[:fields])

        if block_given?
          yield self
        end
      }
    end

    def self.url_block(is_active = false, options = {})
      if is_active.is_a?(Hash)
        is_active, options = (is_active[:active] || false), is_active
      end
      fields = (options[:fields] ||= {})
      field_names = [:slugs, :text_slug]
      field_showings = get_field_showings(fields, field_names)

      Proc.new {
        active is_active
        label options[:label] || I18n.t('hancock.url')
        field :slugs, :hancock_slugs  if field_showings[:slugs]
        field :text_slug              if field_showings[:text_slug]

        Hancock::RailsAdminGroupPatch::hancock_cms_group(self, options[:fields])

        if block_given?
          yield self
        end
      }
    end

    def self.content_block(is_active = false, options = {})
      if is_active.is_a?(Hash)
        is_active, options = (is_active[:active] || false), is_active
      end
      fields = (options[:fields] ||= {})
      field_names = [:excerpt, :content]
      field_showings = get_field_showings(fields, field_names)

      Proc.new {
        active is_active
        label options[:label] || I18n.t('hancock.content')
        field :excerpt, :hancock_html  if field_showings[:excerpt]
        field :content, :hancock_html  if field_showings[:content]

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
      fields = (options[:fields] ||= {})
      field_names = [:main_category, :categories]
      field_showings = get_field_showings(fields, field_names)

      Proc.new {
        active is_active
        label options[:label] || I18n.t('hancock.categories')

        field :main_category do
          inline_add false
          inline_edit false
        end if field_showings[:main_category]
        field :categories, :hancock_multiselect if field_showings[:categories]

        Hancock::RailsAdminGroupPatch::hancock_cms_group(self, options[:fields] || {})

        if block_given?
          yield self
        end
      }
    end


    def self.insertions_block(is_active = false, options = {})
      if is_active.is_a?(Hash)
        is_active, options = (is_active[:active] || false), is_active
      end
      fields = (options[:fields] ||= {})
      field_names = [:possible_insertions]
      field_showings = get_field_showings(fields, field_names)

      Proc.new {
        active is_active
        label options[:label] || I18n.t('hancock.insertions')
        field :possible_insertions do
          read_only true
          pretty_value do
            ("<dl class='possible_insertions_list'>" + bindings[:object].possible_insertions.map do |_ins|
              "<dt>#{_ins}</dt><dd>#{bindings[:object].send(_ins)}</dd>"
            end.join + "</dl>").html_safe
          end
        end if field_showings[:possible_insertions]

        Hancock::RailsAdminGroupPatch::hancock_cms_group(self, options[:fields] || {})

        if block_given?
          yield self
        end
      }
    end

    def self.get_field_showings(fields, field_names)
      field_showings = field_names.map { |f| {f => true } }.inject(&:merge) || {}
      if fields.is_a?(Hash)
        field_names.each do |f|
          field_showings[f] = (fields[f] != false)
        end
      elsif fields.is_a?(Array)
        _fields = fields.map { |f| f[:fields] }.inject(&:merge) || {}
        field_names.each do |f|
          field_showings[f] = (_fields[f] != false)
        end
      end
      field_showings
    end

  end
end
