module RailsAdmin
  module Config
    # Provides accessors and autoregistering of model's fields.
    module HasFields

    protected

      # Raw fields.
      # Recursively returns parent section's raw fields
      # Duping it if accessed for modification.
      def _fields(readonly = false)
        return @_fields if @_fields
        return @_ro_fields if readonly && @_ro_fields

        if self.class == RailsAdmin::Config::Sections::Base
          @_ro_fields = @_fields = RailsAdmin::Config::Fields.factory(self)
        else
          # parent is RailsAdmin::Config::Model, recursion is on Section's classes
          @_ro_fields ||= parent.send(self.class.superclass.to_s.underscore.split('/').last)._fields(true)
          @_ro_fields.freeze if Rails.env.production? or Rails.env.staging?
        end
        readonly ? @_ro_fields : (@_fields ||= @_ro_fields.collect(&:clone))
      end
    end
  end
end
