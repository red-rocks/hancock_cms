module Hancock::Enableable
  extend ActiveSupport::Concern
  include Hancock::BooleanField

  included do
    boolean_field(:enabled)
  end
end
