module Hancock
  module RailsAdminSettingsPatch
    extend ActiveSupport::Concern

    included do
      ::Hancock.register_model(self)

      include ::Hancock::RailsAdminPatch

      # t = {_all: 'Все'}
      ::RailsAdminSettings::Setting.distinct(:ns).each do |c|
        s = "ns_#{c.gsub('-', '_')}".to_sym
        scope s, -> { where(ns: c) }
        # t[s] = c
      end
      # I18n.backend.store_translations(:ru, {admin: {scopes: {'rails_admin_settings/setting': t}}})

      field :for_admin, type: Boolean, default: -> {
        !!(self.ns == "admin" or self.ns =~ /\Aadmin(\.\w+)*\z/)
      }
      def for_admin?
        self.for_admin
      end

      # def self.manager_can_default_actions
      #   # [:index, :show, :read, :edit, :update]
      #   super - [:new, :create]
      # end
      # def self.manager_can_default_actions
      #   ret =
      #   # ret << :model_accesses if ::Hancock::Goto.config.user_abilities_support
      #   ret
      # end
      def self.manager_can_add_actions
        ret = []
        # ret << :model_accesses if defined?(::RailsAdminUserAbilities)
        ret += [:comments, :model_comments] if defined?(::RailsAdminComments)
        ret << :hancock_touch if defined?(::Hancock::Cache::Cacheable)
        ret.freeze
      end
      def self.manager_cannot_add_actions
        [:new, :create, :delete, :destroy]
      end

      def self.rails_admin_add_visible_actions
        ret = manager_can_actions.dup
        ret << :model_accesses if defined?(::RailsAdminUserAbilities)
        ret += [:comments, :model_comments] if defined?(::RailsAdminComments)
        ret << :hancock_touch if defined?(::Hancock::Cache::Cacheable)
        ret.freeze
      end


      rails_admin do
        navigation_label I18n.t('admin.settings.label')

        list do
          field :label do
            visible false
            searchable true
            weight 1
          end
          field :enabled, :toggle do
            weight 2
          end
          field :loadable, :toggle do
            weight 3
          end
          field :ns do
            searchable true
            weight 4
          end
          field :key do
            searchable true
            weight 5
          end
          field :name do
            weight 6
          end
          field :kind do
            searchable true
            weight 7
          end
          field :raw do
            weight 8
            searchable true
            pretty_value do
              if bindings[:object].file_kind?
                "<a href='#{CGI::escapeHTML(bindings[:object].file.url)}'>#{CGI::escapeHTML(bindings[:object].to_path)}</a>".html_safe.freeze
              elsif bindings[:object].image_kind?
                "<a href='#{CGI::escapeHTML(bindings[:object].file.url)}'><img src='#{CGI::escapeHTML(bindings[:object].file.url)}' /></a>".html_safe.freeze
              else
                value
              end
            end
          end
          field :cache_keys_str, :text do
            weight 10
            searchable true
          end
          if ::Settings.table_exists?
            nss = ::RailsAdminSettings::Setting.distinct(:ns).map { |c| "ns_#{c.gsub('-', '_')}".to_sym }
            scopes([nil] + nss)
          end
        end

        edit do
          field :enabled, :toggle do
            weight 1
            visible do
              if bindings[:object].for_admin?
                render_object = (bindings[:controller] || bindings[:view])
                render_object and (render_object.current_user.admin?)
              else
                true
              end
            end
          end
          field :loadable, :toggle do
            weight 2
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and (render_object.current_user.admin?)
            end
          end
          field :for_admin, :toggle do
            weight 3
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and (render_object.current_user.admin?)
            end
          end
          field :ns  do
            weight 4
            read_only true
            help false
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and (render_object.current_user.admin?)
            end
          end
          field :key  do
            weight 5
            read_only true
            help false
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and (render_object.current_user.admin?)
            end
          end
          field :label, :string do
            weight 6
            read_only do
              render_object = (bindings[:controller] || bindings[:view])
              !render_object or !(render_object.current_user.admin?)
            end
            help false
          end
          field :kind, :enum do
            weight 7
            read_only do
              render_object = (bindings[:controller] || bindings[:view])
              !render_object or !(render_object.current_user.admin?)
            end
            enum do
              RailsAdminSettings.kinds
            end
            partial "enum_for_settings_kinds".freeze
            help false
          end
          field :raw do
            weight 8
            partial "setting_value".freeze
            visible do
              !bindings[:object].upload_kind?
            end
            read_only do
              if bindings[:object].for_admin?
                render_object = (bindings[:controller] || bindings[:view])
                !(render_object and (render_object.current_user.admin?))
              else
                false
              end
            end
          end
          if Settings.file_uploads_supported
            field :file, Settings.file_uploads_engine do
              weight 9
              visible do
                bindings[:object].upload_kind?
              end
              read_only do
                if bindings[:object].for_admin?
                  render_object = (bindings[:controller] || bindings[:view])
                  !(render_object and (render_object.current_user.admin?))
                else
                  false
                end
              end
            end
          end

          field :cache_keys_str, :text do
            weight 10
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and render_object.current_user.admin?
            end
          end

        end
      end

    end

  end
end
