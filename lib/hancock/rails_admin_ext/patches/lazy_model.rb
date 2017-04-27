require 'rails_admin/config/lazy_model'

module RailsAdmin
  module Config
    class LazyModel

      def get_deferred_blocks
        @deferred_blocks.clone
      end

    end
  end
end
