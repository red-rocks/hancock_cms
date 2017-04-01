module Hancock
  module Models
    module EmbeddedElement
      extend ActiveSupport::Concern

      include Hancock::Model
      include Hancock::Enableable
      include Hancock::Sortable

      include Hancock.orm_specific('EmbeddedElement')
      
    end
  end
end
