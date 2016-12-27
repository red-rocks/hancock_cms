module Hancock
  module RailsAdminSettingsPatch
    extend ActiveSupport::Concern

    included do
      Hancock.register_model(self)

      include Hancock::RailsAdminPatch

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
    end

  end
end
