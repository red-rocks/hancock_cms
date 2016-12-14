if Hancock.mongoid?

  module Hancock::Cacheable
    extend ActiveSupport::Concern

    included do
      field :cache_keys_str, type: String, default: -> { default_cache_keys.join("\n") }
      def self.default_cache_keys
        []
      end
      def default_cache_keys
        self.class.default_cache_keys
      end
      def set_default_cache_keys(strategy = :append)
        _old_keys = cache_keys

        _keys = case strategy.to_sym
        when :append
          (_old_keys + default_cache_keys).uniq
        when :overwrite, :replace
          default_cache_keys
        else
          _old_keys
        end
        self
      end
      def set_default_cache_keys!(strategy = :append)
        self.set_default_cache_keys(strategy) and self.save
      end


      def cache_keys
        cache_keys_str.split(/\s+/).map { |k| k.strip }.reject { |k| k.blank? }
      end
      field :perform_caching, type: Boolean, default: true

      after_touch :clear_cache
      after_save :clear_cache
      after_destroy :clear_cache
      def clear_cache
        if perform_caching
          cache_keys.each do |k|
            Rails.cache.delete(k)
          end
        end
      end

    end
  end

end
