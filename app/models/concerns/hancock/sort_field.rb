module Hancock::SortField
  extend ActiveSupport::Concern

  class_methods do

    def sort_field(prefix = '', opts = {type: Integer, default: 0})
      if prefix.is_a?(Hash)
        opts = prefix
        prefix = opts.delete(:prefix) || ""
      end
      prefix = "#{prefix}_" unless prefix == ''

      if Hancock.mongoid?
        field "#{prefix}order".to_sym, opts
        alias_method "#{prefix}sort", "#{prefix}order"
        scope "#{prefix}ordered".to_sym,  -> { asc("#{prefix}order".to_sym) }
        scope "#{prefix}sorted".to_sym,   -> { asc("#{prefix}order".to_sym) }
      end
      if Hancock.active_record?
        scope "#{prefix}ordered".to_sym,  -> { order("#{prefix}order".to_sym => :asc) }
        scope "#{prefix}sorted".to_sym,   -> { order("#{prefix}order".to_sym => :asc) }
      end


      class_eval <<-RUBY
        def set_default_#{prefix}order_value
          if (_embed_method = self.try(:embed_method_for_parent))
            begin
              if (self.#{prefix}order.nil? or self.#{prefix}order == 0) and (_parent = self._parent)
                self.#{prefix}order = _parent.send(_embed_method).max("#{prefix}order").to_i + 1
              end
            rescue
            end
          end
          self.#{prefix}order ||= 0
          self
        end
      RUBY
    end

  end

end
