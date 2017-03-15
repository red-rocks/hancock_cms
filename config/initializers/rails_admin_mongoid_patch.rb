require 'rails_admin/adapters/mongoid'
module RailsAdmin
  module Adapters
    module Mongoid

      def sort_by(options, scope)
        return scope unless options[:sort]

        case options[:sort]
        when String
          field_name, collection_name = options[:sort].split('.').reverse
          # if collection_name && collection_name != table_name
          #   raise('sorting by associated model column is not supported in Non-Relational databases')
          # end
        when Symbol
          field_name = options[:sort].to_s
        end
        if options[:sort_reverse]
          scope.asc field_name
        else
          scope.desc field_name
        end
      end

    end
  end
end
