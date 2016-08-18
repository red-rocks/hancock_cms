module Hancock::Sortable
  extend ActiveSupport::Concern
  include Hancock::SortField

  included do
    sort_field
  end
end
