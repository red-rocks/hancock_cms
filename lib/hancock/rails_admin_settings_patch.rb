module Hancock
  module RailsAdminSettingsPatch
    extend ActiveSupport::Concern

    included do
      Hancock.register_model(self)

      include Hancock::RailsAdminPatch
      if Hancock.config.mongoid_single_collection
        include Hancock::MasterCollection
      end
      ::RailsAdminSettings::Setting.pluck(:ns).uniq.each do |c|
         s = "ns_#{c.gsub('-', '_')}".to_sym
         scope s, -> { where(ns: c) }
         # t[s] = c
       end

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
      #   # ret << :model_accesses if Hancock::Goto.config.user_abilities_support
      #   ret
      # end
      def self.manager_can_add_actions
        ret = []
        # ret << :model_accesses if defined?(RailsAdminUserAbilities)
        ret += [:comments, :model_comments] if defined?(RailsAdminComments)
        ret << :hancock_touch if defined?(Hancock::Cache::Cacheable)
        ret.freeze
      end
      def self.manager_cannot_add_actions
        [:new, :create, :delete, :destroy]
      end

      def self.rails_admin_add_visible_actions
        ret = manager_can_actions.dup
        ret << :model_accesses if defined?(RailsAdminUserAbilities)
        ret += [:comments, :model_comments] if defined?(RailsAdminComments)
        ret << :hancock_touch if defined?(Hancock::Cache::Cacheable)
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
          if Object.const_defined?('RailsAdminToggleable')
            field :enabled, :toggle do
              weight 2
            end
          else
            field :enabled do
              weight 2
            end
          end
          field :ns do
            searchable true
            weight 3
          end
          field :key do
            searchable true
            weight 4
          end
          field :name do
            weight 5
          end
          field :kind do
            searchable true
            weight 6
          end
          field :raw do
            weight 7
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
            weight 6
            searchable true
          end
          if ::Settings.table_exists?
            nss = ::RailsAdminSettings::Setting.pluck(:ns).uniq.map { |c| "ns_#{c.gsub('-', '_')}".to_sym }
            scopes([nil] + nss)
          end
        end

        edit do
          field :enabled, :toggle do
            visible do
              if bindings[:object].for_admin?
                render_object = (bindings[:controller] || bindings[:view])
                render_object and (render_object.current_user.admin?)
              else
                true
              end
            end
          end
          field :for_admin, :toggle do
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and (render_object.current_user.admin?)
            end
          end
          field :ns  do
            read_only true
            help false
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and (render_object.current_user.admin?)
            end
          end
          field :key  do
            read_only true
            help false
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and (render_object.current_user.admin?)
            end
          end
          field :label do
            read_only true
            help false
          end
          field :kind do
            read_only true
            help false
          end
          field :raw do
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
