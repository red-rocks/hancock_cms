if Hancock.mongoid?
  module Hancock::MasterCollection
    extend ActiveSupport::Concern

    included do
      if Hancock.config.mongoid_single_collection
        if Hancock.config.mongoid_single_collection == true
          _collection_name = :hancock_master_collection
        else
          _collection_name = Hancock.config.mongoid_single_collection
        end
        store_in collection: _collection_name

        field(:_type, default: self.name, type: String)
        default_scope -> { where(_type: self.name) }

        def self.hereditary?
          true
        end

        def self.inherited(subclass)
          subclass.field(:_id, default: -> { BSON::ObjectId.new }, type: BSON::ObjectId, pre_processed: true, overwrite: true)
          subclass.field(:_type, default: subclass.name, type: String, overwrite: true)
          subclass.default_scope -> { where(_type: subclass.name) }
        end

      end
    end

  end
end
