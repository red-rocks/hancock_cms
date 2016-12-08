module Hancock
  module Model
    extend ActiveSupport::Concern
    included do
      Hancock.register_model(self)

      if Hancock.mongoid?
        include Mongoid::Document
        include Mongoid::Timestamps::Short

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
    end

  end
end
