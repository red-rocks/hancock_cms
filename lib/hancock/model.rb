module Hancock
  module Model
    extend ActiveSupport::Concern
    included do
      Hancock.register_model(self)

      if Hancock.mongoid?
        include Mongoid::Document
        include Mongoid::Timestamps::Short

        if Hancock.config.mongoid_single_collection
          include Hancock::MasterCollection
        end

        if Hancock.config.localize
          include Hancock::ModelLocalizeable
        end
      end

      include ActiveModel::ForbiddenAttributesProtection
      include Hancock::BooleanField
      include Hancock::SortField

      if Hancock.mongoid? and defined?(RailsAdminComments)
        include RailsAdminComments::Commentable
        include RailsAdminComments::ModelCommentable
      end

      if Hancock.config.history_tracking
        if Hancock.mongoid?
          if defined?(TrackablePatch)
            include TrackablePatch
          elsif defined?(Trackable)
            include Trackable
          end
        end
      end

      include Hancock::RailsAdminPatch

      # TODO cache_version fix
      def cache_version
        try(:u_at) || try(:updated_at)
      end
    end


    class_methods do

      def inherited(base)
        Hancock.register_model(base)
        super
      end

    end

  end
end
