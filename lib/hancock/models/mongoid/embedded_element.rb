module Hancock
  module Models
    module Mongoid
      module EmbeddedElement
        extend ActiveSupport::Concern

        include Hancock::EmbeddedFindable

        included do
          field :name, type: String, localize: Hancock.configuration.localize, default: ""
        end

      end
    end
  end
end
