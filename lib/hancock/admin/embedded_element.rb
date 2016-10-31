module Hancock
  module Admin
    module EmbeddedElement
      def self.config(nav_label = nil, fields = {})
        if nav_label.is_a?(Hash)
          nav_label, fields = nil, nav_label
        end
        Proc.new {
          navigation_label(nav_label || I18n.t('hancock.cms'))
          field :enabled, :toggle do
            searchable false
          end
          field :name, :string do
            searchable true
          end

          Hancock::RailsAdminGroupPatch::hancock_cms_group(self, fields)

          if block_given?
            yield self
          end
        }
      end
    end
  end
end
