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

        _collection_name = collection_name.to_s
        if _collection_name =~ /^hancock_/
          enjoy_collection_name = _collection_name.sub(/^hancock_/, 'enjoy_')
          if Mongoid.client('default').collections.map(&:name).include?(enjoy_collection_name)
            modules = []
            self.name.sub("Hancock", "Enjoy").split("::").each do |mod|
              modules << mod
              eval("::#{modules.join("::")} ||= #{modules.join("::").sub("Enjoy", "Hancock")}")
            end
            store_in collection: enjoy_collection_name
          end
        end

        def self.goto_hancock
        end
      end

      include ActiveModel::ForbiddenAttributesProtection
      include Hancock::BooleanField
      include Hancock::SortField

      if Hancock.mongoid? and defined?(RailsAdminComments)
        include RailsAdminComments::Commentable
        include RailsAdminComments::ModelCommentable
      end

      if false #temp Hancock.mongoid? && defined?(Trackable)
        include Trackable
      end

      include Hancock::RailsAdminPatch
    end

  end
end
