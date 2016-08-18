if defined?(Mongoid)

  module Mongoid

    # Helps to override find method in an embedded document.
    # Usage :
    #   - add to your model "include Mongoid::EmbeddedFindable"
    #   - override find method with:
    #     def self.find(id)
    #       find_through(Book, 'chapter', id)
    #     end
    module EmbeddedFindable

      extend ActiveSupport::Concern

      included do

        # Search an embedded document by id.
        #
        # Document is stored within embedding_class collection, and can be accessed through provided relation.
        # Also supports chained relationships (if the searched document is nested in several embedded documents)
        #
        # Example, with a chapter embedded in a book, the book being embedded in a library.
        # use find_through(Library, "books", book_id) in Book class
        # and find_through(Library, "books.chapters", chapter_id) in Chapter class
        def self.find_through(embedding_class, relation, id = nil)
          return nil if id.nil? || id.blank?

          id = BSON::ObjectId.from_string(id) if id.is_a?(String)
          relation = relation.to_s unless relation.is_a?(String)

          relation_parts = relation.split('.')
          parent = embedding_class.send(:all)

          while relation_parts.length > 0
            item = if parent.is_a?(Mongoid::Criteria) || parent.is_a?(Array)
                     parent.where("#{relation_parts.join('.')}._id" => id).first
                   else
                     parent
                   end
            return nil if item.nil?
            parent = item.send(relation_parts.shift)
          end

          if parent.is_a?(Mongoid::Criteria) || parent.is_a?(Array)
            parent.where('_id' => id).first
          else
            parent
          end
        end

      end

    end

  end
end
