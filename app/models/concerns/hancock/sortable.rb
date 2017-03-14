module Hancock::Sortable
  extend ActiveSupport::Concern
  include Hancock::SortField

  included do
    sort_field

    before_create :set_default_order_value
  end

end
