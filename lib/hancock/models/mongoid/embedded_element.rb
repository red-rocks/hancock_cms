module Hancock
  module Models
    module Mongoid
      module EmbeddedElement
        extend ActiveSupport::Concern

        include Hancock::EmbeddedFindable

        included do
          field :name, type: String, localize: Hancock.configuration.localize, default: ""

          # stolen from https://github.com/mongoid/mongoid-history/blob/master/lib/mongoid/history/trackable.rb#L171
          def embed_method_for_parent
            ret = nil
            if self._parent
              ret = self._parent.relations.values.find do |relation|
                if ::Mongoid::Compatibility::Version.mongoid3?
                  relation.class_name == self.metadata.class_name.to_s && relation.name == self.metadata.name
                else
                  # TODO error (relation_metadata not exists)
                  relation.class_name == self.relation_metadata.class_name.to_s &&
                  relation.name == self.relation_metadata.name
                end
              end
            end
            ret and ret.name
          end

          def to_param
            (super or id.to_s) rescue id.to_s
          end

        end

      end
    end
  end
end
