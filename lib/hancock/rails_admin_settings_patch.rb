module Hancock
  module RailsAdminSettingsPatch
    extend ActiveSupport::Concern

    included do
      ::Hancock.register_model(self)

      include ::Hancock::RailsAdminPatch
      if ::Hancock.config.mongoid_single_collection
        include ::Hancock::MasterCollection
      end

      if RailsAdminSettings.mongoid?
        field :for_admin, type: Boolean, default: -> {
          !!(self.ns == "admin" or self.ns =~ /\Aadmin(\.\w+)*\z/)
        }
      end
      def for_admin?
        false
      end

      def val
        ((upload_kind? and !file.blank?) ? file.url : value)
      end
      def value
        ((upload_kind? and !file.blank?) ? file.url : super)
      end
      def processed_value
        ((upload_kind? and !file.blank?) ? file.url : super)
      end
      def blank?
        if upload_kind?
          file.blank?
        else
          super
        end
      end

      # def self.manager_can_default_actions
      #   # [:index, :show, :read, :edit, :update]
      #   super - [:new, :create]
      # end
      # def self.manager_can_default_actions
      #   ret = []
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
        # navigation_label I18n.t('admin.settings.label')

        list do
          field :label do
            visible false
            # searchable true
            weight 1
          end
          field :enabled, :toggle do
            weight 2
          end
          field :loadable, :toggle do
            weight 3
          end
          field :ns do
            # searchable true
            weight 4
          end
          field :key do
            # searchable true
            weight 5
          end
          field :name do
            weight 6
          end
          field :kind do
            # searchable true
            weight 7
          end
          field :raw_data do
            weight 8
            # pretty_value do
            #   if bindings[:object].file_kind?
            #     "<a href='#{CGI::escapeHTML(bindings[:object].file.url)}'>#{CGI::escapeHTML(bindings[:object].to_path)}</a>".html_safe.freeze
            #   elsif bindings[:object].image_kind?
            #     "<a href='#{CGI::escapeHTML(bindings[:object].file.url)}'><img src='#{CGI::escapeHTML(bindings[:object].file.url)}' /></a>".html_safe.freeze
            #   elsif bindings[:object].array_kind?
            #     (bindings[:object].raw_array || []).join("<br>").html_safe
            #   elsif bindings[:object].hash_kind?
            #     "<pre>#{JSON.pretty_generate(bindings[:object].raw_hash || {})}</pre>".html_safe
            #   else
            #     value
            #   end
            # end
          end
          field :raw do
            weight 8
            # searchable true
            # visible false
            # pretty_value do
            #   if bindings[:object].file_kind?
            #     "<a href='#{CGI::escapeHTML(bindings[:object].file.url)}'>#{CGI::escapeHTML(bindings[:object].to_path)}</a>".html_safe.freeze
            #   elsif bindings[:object].image_kind?
            #     "<a href='#{CGI::escapeHTML(bindings[:object].file.url)}'><img src='#{CGI::escapeHTML(bindings[:object].file.url)}' /></a>".html_safe.freeze
            #   else
            #     value
            #   end
            # end
          end
          field :raw_array do
            weight 9
            # searchable true
            # visible false
            # pretty_value do
            #   (bindings[:object].raw_array || []).join("<br>").html_safe
            # end
          end
          field :raw_hash do
            weight 10
            # searchable true
            # visible false
            # pretty_value do
            #   "<pre>#{JSON.pretty_generate(bindings[:object].raw_hash || {})}</pre>".html_safe
            # end
          end
          field :cache_keys_str, :text do
            weight 11
            searchable true
          end
          if ::Settings.table_exists?
            nss = ::RailsAdminSettings::Setting.pluck(:ns).map { |c|
              next if c =~ /^rails_admin_model_settings_/ and defined?(RailsAdminModelSettings)
              "ns_#{c.gsub('-', '_')}".to_sym
            }.compact
          else
            nss = []
          end
          if defined?(RailsAdminModelSettings)
            scopes([:no_model_settings, :model_settings, nil] + nss)
          else
            scopes([nil] + nss)
          end
        end

        edit do
          field :enabled, :toggle do
            weight 1
            visible do
              if bindings[:object].for_admin?
                is_current_user_admin
              else
                true
              end
            end
          end
          field :loadable, :toggle do
            weight 2
            visible do
              is_current_user_admin
            end
          end
          field :for_admin, :toggle do
            weight 3
            visible do
              is_current_user_admin
            end
          end
          field :ns  do
            weight 4
            read_only true
            help false
            visible do
              is_current_user_admin
            end
          end
          field :key  do
            weight 5
            read_only true
            help false
            visible do
              is_current_user_admin
            end
          end
          field :label, :string do
            weight 6
            read_only do
              !is_current_user_admin
            end
            help false
          end
          field :kind, :enum do
            weight 7
            read_only do
              !is_current_user_admin
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
            # visible do
            #   !bindings[:object].upload_kind? and !bindings[:object].array_kind? and !bindings[:object].hash_kind?
            # end

            visible do
              bindings[:object] and !bindings[:object].upload_kind? and !bindings[:object].array_kind? and !bindings[:object].hash_kind?
            end
            read_only do
              if bindings[:object].for_admin?
                !is_current_user_admin
              else
                false
              end
            end
          end
          field :raw_array do
            weight 9
            partial "setting_value".freeze
            formatted_value do
              (bindings[:object].raw_array || [])
            end
            pretty_value do
              formatted_value.map(&:to_s).join("<br>").html_safe
            end
            visible do
              bindings[:object].array_kind?
            end
            read_only do
              if bindings[:object].for_admin?
                !is_current_user_admin
              else
                false
              end
            end
          end
          field :raw_hash do
            weight 10
            partial "setting_value".freeze
            formatted_value do
              (bindings[:object].raw_hash || {})
            end
            pretty_value do
              "<pre>#{JSON.pretty_generate(formatted_value)}</pre>".html_safe
            end
            visible do
              bindings[:object].hash_kind?
            end
            read_only do
              if bindings[:object].for_admin?
                !is_current_user_admin
              else
                false
              end
            end
          end
          if Settings.file_uploads_supported
            field :file, Settings.file_uploads_engine do
              weight 11
              visible do
                bindings[:object].upload_kind?
              end
              read_only do
                if bindings[:object].for_admin?
                  !is_current_user_admin
                else
                  false
                end
              end
            end
          end

          field :cache_keys_str, :text do
            weight 10
            visible do
              is_current_user_admin
            end
          end

        end
      end

    end

  end
end



class ::Settings

  def self.exists?(key)
    !getnc(key).nil?
  end
  def self.enabled?(key)
    getnc(key).enabled?
  end
  def self.rename(old_key, new_key)
    get_default_ns.rename(old_key, new_key)
  end

end
class ::RailsAdminSettings::Namespaced

  def exists?(key)
    !getnc(key).nil?
  end
  def enabled?(key)
    getnc(key).enabled?
  end
  def rename(old_key, new_key)
    _obj = getnc(old_key)
    if _obj
      _obj.key = new_key
      _obj.save
    end
  end
end
