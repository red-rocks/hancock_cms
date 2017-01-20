module Hancock
  module Models
    module Mongoid
      module EmbeddedElement
        extend ActiveSupport::Concern

        include Hancock::EmbeddedFindable

        included do
          field :name, type: String, localize: Hancock.configuration.localize, default: ""

          before_save do
            puts self.inspect
          end
        end

      end
    end
  end
end
