module Hancock
  module Admin
    def self.map_config(is_active = true)
      Proc.new {
        active is_active
        label I18n.t('hancock.map')
        field :address, :string
        field :map_address, :string
        field :map_hint, :string
        field :coordinates, :string do
          read_only true
          formatted_value{ bindings[:object].coordinates.to_json }
        end
        field :lat
        field :lon

        if block_given?
          yield self
        end
      }
    end
  end
end
