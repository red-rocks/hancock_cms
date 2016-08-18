module Hancock
  module Admin
    module EmbeddedElement
      def self.config(_navigation_label = I18n.t('hancock.cms'), fields = {})
        Proc.new {
          # navigation_label(_navigation_label) unless _navigation_label.nil?
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
