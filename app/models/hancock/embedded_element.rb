module Hancock
  if Hancock.mongoid?
    class EmbeddedElement
      include Hancock::Models::EmbeddedElement

      include Hancock::Decorators::EmbeddedElement


      # use it in inherited model
      # rails_admin &Hancock::Admin::EmbeddedElement.config

      # use it in rails_admin in parent model for sort
      # sort_embedded({fields: [:embedded_field_1, :embedded_field_2...]})
      # or u need to override rails_admin in inherited model to add sort field
    end
  end
end
