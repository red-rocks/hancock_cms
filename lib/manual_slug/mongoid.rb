module ManualSlug::Mongoid
  extend ActiveSupport::Concern
  include ::Mongoid::Slug

  def text_slug
    ((self._slugs.nil? or self._slugs.empty?) ? '' : self._slugs.last)
  end
  def text_slug=(slug)
    self._slugs ||= []
    if slug.blank?
      self._slugs = []
    else
      self._slugs.delete(slug)
      self._slugs << slug
    end
  end

  module ClassMethods
    def manual_slug(_field, options = {}, callback = true)
      options.merge!({
        permanent: true,
        history: true,
        scope: (Hancock.config.mongoid_single_collection ? :_type : nil)
      })
      
      slug _field, options
      #overwrite for default value
      field :_slugs, type: Array, localize: options[:localize], default: [], overwrite: true


      # we will create slugs manually when needed
      skip_callback :create, :before, :build_slug

      before_validation do
        self._slugs = self._slugs.map{ |s| s.strip }.reject {|s| s.blank? } if self._slugs

        if self._slugs.blank?
          self.build_slug
        end

        true
      end if callback
    end
  end
end
